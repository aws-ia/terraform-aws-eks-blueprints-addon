provider "aws" {
  region = local.region
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  apply_retry_count      = 30
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_id
}

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}

locals {
  name       = basename(path.cwd)
  region     = "us-west-2"
  account_id = data.aws_caller_identity.current.account_id

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  karpenter_tag_key = "karpenter.sh/discovery/${local.name}"

  tags = {
    Example    = local.name
    GithubRepo = "aws-ia/terraform-aws-eks-addon"
  }
}

################################################################################
# EKS Addon
################################################################################

module "helm_release_only" {
  source = "../../"

  chart         = "metrics-server"
  chart_version = "3.8.2"
  repository    = "https://kubernetes-sigs.github.io/metrics-server/"
  description   = "Metric server helm Chart deployment configuration"
  namespace     = "kube-system"

  values = [
    <<-EOT
      podDisruptionBudget:
        maxUnavailable: 1
      metrics:
        enabled: true
    EOT
  ]

  set = [
    {
      name  = "replicas"
      value = 3
    }
  ]
}

module "helm_release_irsa" {
  source = "../../"

  chart            = "karpenter"
  chart_version    = "0.16.2"
  repository       = "https://charts.karpenter.sh/"
  description      = "Kubernetes Node Autoscaling: built for flexibility, performance, and simplicity"
  namespace        = "karpenter"
  create_namespace = true

  set = [
    {
      name  = "clusterName"
      value = module.eks.cluster_id
    },
    {
      name  = "clusterEndpoint"
      value = module.eks.cluster_endpoint
    },
    {
      name  = "aws.defaultInstanceProfile"
      value = aws_iam_instance_profile.karpenter.name
    }
  ]

  set_irsa_name = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  # # Equivalent to the following but the ARN is only known internally to the module
  # set = [{
  #   name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
  #   value = iam_role_arn.this[0].arn
  # }]

  # IAM role for service account (IRSA)
  create_role = true
  role_name   = "karpenter-controller"
  role_policy_arns = {
    karpenter = aws_iam_policy.karpenter_controller.arn
  }

  oidc_providers = {
    this = {
      provider_arn = module.eks.oidc_provider_arn
      # namespace is inherited from chart
      service_account = "karpenter"
    }
  }

  tags = local.tags
}

module "irsa_only" {
  source = "../../"

  # Disable helm release
  create_release = false

  # IAM role for service account (IRSA)
  create_role = true
  role_name   = "aws-vpc-cni-ipv4"
  role_policy_arns = {
    AmazonEKS_CNI_Policy = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  }

  oidc_providers = {
    this = {
      provider_arn    = module.eks.oidc_provider_arn
      namespace       = "kube-system"
      service_account = "aws-node"
    }
  }

  tags = local.tags
}

module "disabled" {
  source = "../../"

  create = false
}

################################################################################
# Supporting resources
################################################################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 18.30"

  cluster_name    = local.name
  cluster_version = "1.23"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.private_subnets
  control_plane_subnet_ids = module.vpc.intra_subnets

  node_security_group_additional_rules = {
    # Control plane invoke Karpenter webhook
    ingress_karpenter_webhook_tcp = {
      description                   = "Control plane invoke Karpenter webhook"
      protocol                      = "tcp"
      from_port                     = 8443
      to_port                       = 8443
      type                          = "ingress"
      source_cluster_security_group = true
    }
  }

  eks_managed_node_groups = {
    initial = {
      instance_types        = ["m5.xlarge"]
      create_security_group = false

      min_size     = 1
      max_size     = 2
      desired_size = 1

      iam_role_additional_policies = [
        # Required by Karpenter
        "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      ]
    }
  }

  tags = merge(local.tags, {
    # NOTE - if creating multiple security groups with this module, only tag the
    # security group that Karpenter should utilize with the following tag
    # (i.e. - at most, only one security group should have this tag in your account)
    (local.karpenter_tag_key) = local.name
  })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 3.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 52)]

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  # Manage so we can name
  manage_default_network_acl    = true
  default_network_acl_tags      = { Name = "${local.name}-default" }
  manage_default_route_table    = true
  default_route_table_tags      = { Name = "${local.name}-default" }
  manage_default_security_group = true
  default_security_group_tags   = { Name = "${local.name}-default" }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
    # Tags subnets for Karpenter auto-discovery
    (local.karpenter_tag_key) = local.name
  }

  tags = local.tags
}

resource "aws_iam_instance_profile" "karpenter" {
  name = "KarpenterNodeInstanceProfile-${local.name}"
  role = module.eks.eks_managed_node_groups["initial"].iam_role_name

  tags = local.tags
}

data "aws_iam_policy_document" "karpenter_controller" {
  statement {
    actions = [
      "ec2:CreateLaunchTemplate",
      "ec2:CreateFleet",
      "ec2:CreateTags",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSpotPriceHistory",
      "pricing:GetProducts",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${local.karpenter_tag_key}"
      values   = [module.eks.cluster_id]
    }
  }

  statement {
    actions = ["ec2:RunInstances"]
    resources = [
      "arn:aws:ec2:*:${local.account_id}:launch-template/*",
      "arn:aws:ec2:*:${local.account_id}:security-group/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/${local.karpenter_tag_key}"
      values   = [module.eks.cluster_id]
    }
  }

  statement {
    actions = ["ec2:RunInstances"]
    resources = [
      "arn:aws:ec2:*::image/*",
      "arn:aws:ec2:*:${local.account_id}:instance/*",
      "arn:aws:ec2:*:${local.account_id}:spot-instances-request/*",
      "arn:aws:ec2:*:${local.account_id}:volume/*",
      "arn:aws:ec2:*:${local.account_id}:network-interface/*",
      "arn:aws:ec2:*:${local.account_id}:subnet/*",
    ]
  }

  statement {
    actions   = ["ssm:GetParameter"]
    resources = ["arn:aws:ssm:*:*:parameter/aws/service/*"]
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = [module.eks.eks_managed_node_groups["initial"].iam_role_arn]
  }
}

resource "aws_iam_policy" "karpenter_controller" {
  name_prefix = "Karpenter_Controller_Policy-"
  description = "Provides permissions to handle node termination events via the Node Termination Handler"
  policy      = data.aws_iam_policy_document.karpenter_controller.json

  tags = local.tags
}

################################################################################
# Karpenter Provisioner
################################################################################

# Workaround - https://github.com/hashicorp/terraform-provider-kubernetes/issues/1380#issuecomment-967022975
resource "kubectl_manifest" "karpenter_provisioner" {
  yaml_body = <<-YAML
    ---
    apiVersion: karpenter.sh/v1alpha5
    kind: Provisioner
    metadata:
      name: default
    spec:
      requirements:
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["spot"]
      limits:
        resources:
          cpu: 1000
      providerRef:
        name: default
      ttlSecondsAfterEmpty: 30
  YAML

  depends_on = [
    module.helm_release_irsa.helm_release
  ]
}

resource "kubectl_manifest" "karpenter_node_template" {
  yaml_body = <<-YAML
    apiVersion: karpenter.k8s.aws/v1alpha1
    kind: AWSNodeTemplate
    metadata:
      name: default
    spec:
      subnetSelector:
        ${local.karpenter_tag_key}: ${module.eks.cluster_id}
      securityGroupSelector:
        ${local.karpenter_tag_key}: ${module.eks.cluster_id}
      tags:
        ${local.karpenter_tag_key}: ${module.eks.cluster_id}
  YAML

  depends_on = [
    kubectl_manifest.karpenter_provisioner
  ]
}

# Example deployment using the [pause image](https://www.ianlewis.org/en/almighty-pause-container)
# and starts with zero replicas
resource "kubectl_manifest" "karpenter_example_deployment" {
  yaml_body = <<-YAML
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: inflate
  spec:
    replicas: 0
    selector:
      matchLabels:
        app: inflate
    template:
      metadata:
        labels:
          app: inflate
      spec:
        terminationGracePeriodSeconds: 0
        containers:
          - name: inflate
            image: public.ecr.aws/eks-distro/kubernetes/pause:3.2
            resources:
              requests:
                cpu: 1
  YAML

  depends_on = [
    kubectl_manifest.karpenter_node_template
  ]
}

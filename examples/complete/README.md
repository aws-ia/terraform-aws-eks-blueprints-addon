# Complete AWS EKS Addon Example

Configuration in this directory provisions:
- TODO

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which will incur monetary charges on your AWS bill. Run `terraform destroy` when you no longer need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_disabled"></a> [disabled](#module\_disabled) | ../../ | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 18.30 |
| <a name="module_helm_release_only"></a> [helm\_release\_only](#module\_helm\_release\_only) | ../../ | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_eks_cluster_auth.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_helm_release_only_app_version"></a> [helm\_release\_only\_app\_version](#output\_helm\_release\_only\_app\_version) | The version number of the application being deployed |
| <a name="output_helm_release_only_chart"></a> [helm\_release\_only\_chart](#output\_helm\_release\_only\_chart) | The name of the chart |
| <a name="output_helm_release_only_name"></a> [helm\_release\_only\_name](#output\_helm\_release\_only\_name) | Name is the name of the release |
| <a name="output_helm_release_only_namespace"></a> [helm\_release\_only\_namespace](#output\_helm\_release\_only\_namespace) | Name of Kubernetes namespace |
| <a name="output_helm_release_only_revision"></a> [helm\_release\_only\_revision](#output\_helm\_release\_only\_revision) | Version is an int32 which represents the version of the release |
| <a name="output_helm_release_only_values"></a> [helm\_release\_only\_values](#output\_helm\_release\_only\_values) | The compounded values from `values` and `set*` attributes |
| <a name="output_helm_release_only_version"></a> [helm\_release\_only\_version](#output\_helm\_release\_only\_version) | A SemVer 2 conformant version string of the chart |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/aws-ia/terraform-aws-eks-addon/blob/main/LICENSE).

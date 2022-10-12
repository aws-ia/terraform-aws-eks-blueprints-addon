################################################################################
# Helm Release Only
################################################################################

output "helm_release_only_chart" {
  description = "The name of the chart"
  value       = module.helm_release_only.chart
}

output "helm_release_only_name" {
  description = "Name is the name of the release"
  value       = module.helm_release_only.name
}

output "helm_release_only_namespace" {
  description = "Name of Kubernetes namespace"
  value       = module.helm_release_only.namespace
}

output "helm_release_only_revision" {
  description = "Version is an int32 which represents the version of the release"
  value       = module.helm_release_only.revision
}

output "helm_release_only_version" {
  description = "A SemVer 2 conformant version string of the chart"
  value       = module.helm_release_only.version
}

output "helm_release_only_app_version" {
  description = "The version number of the application being deployed"
  value       = module.helm_release_only.app_version
}

output "helm_release_only_values" {
  description = "The compounded values from `values` and `set*` attributes"
  value       = module.helm_release_only.values
}

output "helm_release_only_iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.helm_release_only.iam_role_arn
}

output "helm_release_only_iam_role_name" {
  description = "Name of IAM role"
  value       = module.helm_release_only.iam_role_name
}

output "helm_release_only_iam_role_path" {
  description = "Path of IAM role"
  value       = module.helm_release_only.iam_role_path
}

output "helm_release_only_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.helm_release_only.iam_role_unique_id
}

################################################################################
# Helm Release & IRSA
################################################################################

output "helm_release_irsa_chart" {
  description = "The name of the chart"
  value       = module.helm_release_irsa.chart
}

output "helm_release_irsa_name" {
  description = "Name is the name of the release"
  value       = module.helm_release_irsa.name
}

output "helm_release_irsa_namespace" {
  description = "Name of Kubernetes namespace"
  value       = module.helm_release_irsa.namespace
}

output "helm_release_irsa_revision" {
  description = "Version is an int32 which represents the version of the release"
  value       = module.helm_release_irsa.revision
}

output "helm_release_irsa_version" {
  description = "A SemVer 2 conformant version string of the chart"
  value       = module.helm_release_irsa.version
}

output "helm_release_irsa_app_version" {
  description = "The version number of the application being deployed"
  value       = module.helm_release_irsa.app_version
}

output "helm_release_irsa_values" {
  description = "The compounded values from `values` and `set*` attributes"
  value       = module.helm_release_irsa.values
}

output "helm_release_irsa_iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.helm_release_irsa.iam_role_arn
}

output "helm_release_irsa_iam_role_name" {
  description = "Name of IAM role"
  value       = module.helm_release_irsa.iam_role_name
}

output "helm_release_irsa_iam_role_path" {
  description = "Path of IAM role"
  value       = module.helm_release_irsa.iam_role_path
}

output "helm_release_irsa_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.helm_release_irsa.iam_role_unique_id
}

################################################################################
# IRSA Only
################################################################################

output "irsa_only_chart" {
  description = "The name of the chart"
  value       = module.irsa_only.chart
}

output "irsa_only_name" {
  description = "Name is the name of the release"
  value       = module.irsa_only.name
}

output "irsa_only_namespace" {
  description = "Name of Kubernetes namespace"
  value       = module.irsa_only.namespace
}

output "irsa_only_revision" {
  description = "Version is an int32 which represents the version of the release"
  value       = module.irsa_only.revision
}

output "irsa_only_version" {
  description = "A SemVer 2 conformant version string of the chart"
  value       = module.irsa_only.version
}

output "irsa_only_app_version" {
  description = "The version number of the application being deployed"
  value       = module.irsa_only.app_version
}

output "irsa_only_values" {
  description = "The compounded values from `values` and `set*` attributes"
  value       = module.irsa_only.values
}

output "irsa_only_iam_role_arn" {
  description = "ARN of IAM role"
  value       = module.irsa_only.iam_role_arn
}

output "irsa_only_iam_role_name" {
  description = "Name of IAM role"
  value       = module.irsa_only.iam_role_name
}

output "irsa_only_iam_role_path" {
  description = "Path of IAM role"
  value       = module.irsa_only.iam_role_path
}

output "irsa_only_iam_role_unique_id" {
  description = "Unique ID of IAM role"
  value       = module.irsa_only.iam_role_unique_id
}

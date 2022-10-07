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

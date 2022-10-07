# AWS EKS Addon Terraform module

Terraform module which provisions an addon on AWS EKS clusters.

## Usage

```hcl
module "eks_addon" {
  source = "aws-ia/eks-addon/aws"

  ## TODO
}
```

## Examples

Examples codified under the [`examples`](https://github.com/aws-ia/terraform-aws-eks-addon) are intended to give users references for how to use the module(s) as well as testing/validating changes to the source code of the module. If contributing to the project, please be sure to make any appropriate updates to the relevant examples to allow maintainers to test your changes and to keep the examples up to date for users. Thank you!

- [Complete](https://github.com/aws-ia/terraform-aws-eks-addon/complete)

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
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used. Defaults to `false` | `bool` | `null` | no |
| <a name="input_chart"></a> [chart](#input\_chart) | Chart name to be installed. The chart name can be local path, a URL to a chart, or the name of the chart if `repository` is specified | `string` | `""` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Specify the exact chart version to install. If this is not specified, the latest version is installed | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | Allow deletion of new resources created in this upgrade when upgrade fails. Defaults to `false` | `bool` | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created (affects all resources) | `bool` | `true` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | Create the namespace if it does not yet exist. Defaults to `false` | `bool` | `null` | no |
| <a name="input_create_release"></a> [create\_release](#input\_create\_release) | Determines whether the Helm release is created | `bool` | `true` | no |
| <a name="input_dependency_update"></a> [dependency\_update](#input\_dependency\_update) | Runs helm dependency update before installing the chart. Defaults to `false` | `bool` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Set release description attribute (visible in the history) | `string` | `null` | no |
| <a name="input_devel"></a> [devel](#input\_devel) | Use chart development versions, too. Equivalent to version '>0.0.0-0'. If version is set, this is ignored | `bool` | `null` | no |
| <a name="input_disable_openapi_validation"></a> [disable\_openapi\_validation](#input\_disable\_openapi\_validation) | If set, the installation process will not validate rendered templates against the Kubernetes OpenAPI Schema. Defaults to `false` | `bool` | `null` | no |
| <a name="input_disable_webhooks"></a> [disable\_webhooks](#input\_disable\_webhooks) | Prevent hooks from running. Defaults to `false` | `bool` | `null` | no |
| <a name="input_force_update"></a> [force\_update](#input\_force\_update) | Force resource update through delete/recreate if needed. Defaults to `false` | `bool` | `null` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | Location of public keys used for verification. Used only if verify is true. Defaults to `/.gnupg/pubring.gpg` in the location set by `home` | `string` | `null` | no |
| <a name="input_lint"></a> [lint](#input\_lint) | Run the helm chart linter during the plan. Defaults to `false` | `bool` | `null` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | Maximum number of release versions stored per release. Defaults to `0` (no limit) | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of the Helm release | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace to install the release into. Defaults to `default` | `string` | `null` | no |
| <a name="input_postrender"></a> [postrender](#input\_postrender) | Configure a command to run after helm renders the manifest which can alter the manifest contents | `any` | `{}` | no |
| <a name="input_recreate_pods"></a> [recreate\_pods](#input\_recreate\_pods) | Perform pods restart during upgrade/rollback. Defaults to `false` | `bool` | `null` | no |
| <a name="input_render_subchart_notes"></a> [render\_subchart\_notes](#input\_render\_subchart\_notes) | If set, render subchart notes along with the parent. Defaults to `true` | `bool` | `null` | no |
| <a name="input_replace"></a> [replace](#input\_replace) | Re-use the given name, only if that name is a deleted release which remains in the history. This is unsafe in production. Defaults to `false` | `bool` | `null` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Repository URL where to locate the requested chart | `string` | `null` | no |
| <a name="input_repository_ca_file"></a> [repository\_ca\_file](#input\_repository\_ca\_file) | The Repositories CA File | `string` | `null` | no |
| <a name="input_repository_cert_file"></a> [repository\_cert\_file](#input\_repository\_cert\_file) | The repositories cert file | `string` | `null` | no |
| <a name="input_repository_key_file"></a> [repository\_key\_file](#input\_repository\_key\_file) | The repositories cert key file | `string` | `null` | no |
| <a name="input_repository_password"></a> [repository\_password](#input\_repository\_password) | Password for HTTP basic authentication against the repository | `string` | `null` | no |
| <a name="input_repository_username"></a> [repository\_username](#input\_repository\_username) | Username for HTTP basic authentication against the repository | `string` | `null` | no |
| <a name="input_reset_values"></a> [reset\_values](#input\_reset\_values) | When upgrading, reset the values to the ones built into the chart. Defaults to `false` | `bool` | `null` | no |
| <a name="input_reuse_values"></a> [reuse\_values](#input\_reuse\_values) | When upgrading, reuse the last release's values and merge in any overrides. If `reset_values` is specified, this is ignored. Defaults to `false` | `bool` | `null` | no |
| <a name="input_set"></a> [set](#input\_set) | Value block with custom values to be merged with the values yaml | `any` | `[]` | no |
| <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive) | Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff | `any` | `[]` | no |
| <a name="input_skip_crds"></a> [skip\_crds](#input\_skip\_crds) | If set, no CRDs will be installed. By default, CRDs are installed if not already present. Defaults to `false` | `bool` | `null` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | Time in seconds to wait for any individual kubernetes operation (like Jobs for hooks). Defaults to `300` seconds | `number` | `null` | no |
| <a name="input_values"></a> [values](#input\_values) | List of values in raw yaml to pass to helm. Values will be merged, in order, as Helm does with multiple `-f` options | `list(string)` | `null` | no |
| <a name="input_verify"></a> [verify](#input\_verify) | Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart. For more information see the Helm Documentation. Defaults to `false` | `bool` | `null` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | Will wait until all resources are in a ready state before marking the release as successful. It will wait for as long as `timeout`. Defaults to `true` | `bool` | `null` | no |
| <a name="input_wait_for_jobs"></a> [wait\_for\_jobs](#input\_wait\_for\_jobs) | If wait is enabled, will wait until all Jobs have been completed before marking the release as successful. It will wait for as long as `timeout`. Defaults to `false` | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_version"></a> [app\_version](#output\_app\_version) | The version number of the application being deployed |
| <a name="output_chart"></a> [chart](#output\_chart) | The name of the chart |
| <a name="output_name"></a> [name](#output\_name) | Name is the name of the release |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Name of Kubernetes namespace |
| <a name="output_revision"></a> [revision](#output\_revision) | Version is an int32 which represents the version of the release |
| <a name="output_values"></a> [values](#output\_values) | The compounded values from `values` and `set*` attributes |
| <a name="output_version"></a> [version](#output\_version) | A SemVer 2 conformant version string of the chart |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Community

- [Code of conduct](.github/CODE_OF_CONDUCT.md)
- [Contributing](.github/CONTRIBUTING.md)
- [Security issue notifications](.github/CONTRIBUTING.md#security-issue-notifications)

## License

Apache-2.0 Licensed. See [LICENSE](https://github.com/aws-ia/terraform-aws-eks-addon/blob/main/LICENSE).

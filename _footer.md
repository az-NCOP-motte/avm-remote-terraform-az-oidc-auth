<!-- markdownlint-disable-next-line MD041 -->

# Pipelines

Azure DevOps pipeline integration (see [pipelines folder](https://github.com/az-NCOP-motte/avm-remote-terraform-az-oidc-auth/tree/development/pipelines)):
- Generate Terraform pipeline plan on PR creation
- Apply Terraform pipeline plan on PR merge
- Agnostic multi-environment (eg. development, staging, prod1, prod2)
- Connected with the service connection
- DevOps Pool integration
- App config integration
- Simple one-time setup using Variable(s) (groups)

It will connect everything automatically:
- TFVARS pre-filled in the app config (with key vault compatibility)
- Example backend config pre-filled (for state migration)
- DevOps pools using alias

![Terraform-git-automation](./docs/implementation-pipeline.svg)

## Requirements

Azure DevOps Marketplace extension:

- [Terraform Microsoft DevLabs](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)


## Pipelines
The following pipelines are used by this module:

### <a name="pipeline_pr-plan"></a> [pr-plan](./pipelines/pr-plan/pr-plan.yaml)

Description: The Plan stage in this pipeline can be configured to trigger on the creation of a PR to generate a Terraform plan for those changes.
Will be used in conjunction with the service connection that was provisioned by the module.

Jobs

- `Generate` - Job for generating and posting a plan based on the Terraform config changes in the PR.

Variables:

- `environment_name` - (Required) The source folder for the Terraform configuration, used to make the pipeline multi-environment.
- `trigger` - (Optional) The trigger is configured through branch policies. Defaults to `none`.
- `pool` - (Optional) The agent pool where the pipeline will be deployed. Defaults to `$(environment_name)-motte-pipeline`.

Steps:

- `Configure git authentication header` - Uses Git CLI to set OIDC WIP Authentication Headers 
- `Extract App Config as File` - Uses Azure CLI to fetch tfvars from App Configuration using the `app-config-endpoint` pipeline variable.
- `Terraform Init` - Uses Terraform Extension task to initialize Terraform.
- `Terraform Plan` - Uses Terraform Extension task to generate a plan and convert it to a text format.
- `Publish Artifact` - Uses Azure task to publish the plan as artifact
- `Post Comment` - Uses Azure CLI to post the plan as a comment to the connected PR.

### <a name="pipeline_merge-apply"></a> [merge-apply](./pipelines/merge-apply/merge-apply.yaml)

Description: This pipeline can be configured to trigger when changes are merged to a branch that manages Terraform configurations.
Will be used in conjunction with the service connection that was provisioned by the module.

Jobs:

- `Apply` - Job for applying a Terraform plan after the PR is approved and merged.
- `Comment` - Job for retrieving and posting apply output from applying a Terraform Plan.

Variables:

- `environment_name` - (Required) The source folder for the Terraform configuration, used to make the pipeline multi-environment.
- `trigger` - (Optional) The trigger is configured on branch merge and can be overridden for secondary staging environments. Defaults to `master`.
- `pool` - (Optional) The agent pool where the pipeline will be deployed. Defaults to `$(environment_name)-motte-pipeline`.

Steps:

- `Configure git authentication header` - Uses Git CLI to set OIDC WIP Authentication Headers 
- `Download Artifact` - Download the Artifact from the Plan pipeline.
- `Terraform Init` - Uses Terraform Extension task to initialize Terraform.
- `Terraform Apply` - Uses Terraform Extension task to apply a plan and convert the output to a text format.
- `Get PR ID` - Uses Azure CLI to retrieve the PR ID.
- `Post Comment` - Uses Azure CLI to post the output as a comment to the connected PR.

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.

variable "devcenters" {
  type = map(object({
    name                = string
    location            = optional(string, null)
    resource_group_name = optional(string, null)

    projects = optional(map(object({
      name                = string
      location            = optional(string, null)
      resource_group_name = optional(string, null)
      # center_key          = string

      pools = optional(map(object({
        name = string
        # project_key         = string
        maximum_concurrency           = number
        storage_account_type          = optional(string, "Standard")
        sku_name                      = optional(string, "Standard_D2ads_v5")
        prediction_profile_automatice = optional(string, "MostCostEffective")
        # image_alias                   = optional(string, "az-pipeline")
        # well_known_image_name         = optional(string, "ubuntu-24.04-g2/latest")
        profile_images = optional(list(object({
          resource_id           = optional(string)
          well_known_image_name = optional(string)
          buffer                = optional(string, "*")
          aliases               = optional(list(string))
          })), [
          {
            "aliases" : [
              "ubuntu-24.04-g2",
              "az-pipeline",
            ],
            "well_known_image_name" : "ubuntu-24.04-g2/latest"
          }
        ])

      })), {})

      role_assignments = optional(map(object({
        role_definition_id_or_name             = string
        principal_id                           = string
        principal_type                         = optional(string, null)
        description                            = optional(string, null)
        skip_service_principal_aad_check       = optional(bool, false)
        condition                              = optional(string, null)
        condition_version                      = optional(string, null)
        delegated_managed_identity_resource_id = optional(string, null)
      })), {})
    })), {})



    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      principal_type                         = optional(string, null)
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
  }))
  default     = {}
  description = <<-EOT
A map of dev centers to create on the parent resource group. The map key is arbitrary; the value supports the following attributes. Defaults to `{}` (no dev centers).

- `name` - (Required) The name of the Container which should be created within the Storage Account. Changing this forces a new resource to be created.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the storage account.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of the storage account.
- `role_assignments` - (Optional) A map of role assignments to create on the container. Defaults to `{}`. See `var.role_assignments` for the attribute schema.
EOT
  nullable    = false
}

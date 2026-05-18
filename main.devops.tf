# TODO: Replace this dummy resource azurerm_resource_group.TODO with your module resource

# Dev Ops Pool
resource "azurerm_dev_center" "example" {
  name                = "terraform-pipeline"
  resource_group_name = azurerm_resource_group.TODO.name
  location            = azurerm_resource_group.TODO.location
}

resource "azurerm_dev_center_project" "example" {
  dev_center_id       = azurerm_dev_center.example.id
  resource_group_name = azurerm_resource_group.TODO.name
  location            = azurerm_resource_group.TODO.location
  name                = "terraform-pipeline"
}

resource "azurerm_managed_devops_pool" "example" {
  name                  = "motte-agent-pool"
  resource_group_name   = azurerm_resource_group.TODO.name
  location              = "Australia East" #todo find better SKU setup
  dev_center_project_id = azurerm_dev_center_project.example.id
  maximum_concurrency   = 1

  azure_devops_organization {
    organization {
      parallelism = 1
      url         = var.devops_organization_url
    }
  }

  stateless_agent {}

  virtual_machine_scale_set_fabric {
    sku_name = "Standard_D2ads_v5"

    image {
      aliases = [
        "ubuntu-24.04-g2",
        "az-pipeline", # add alias so that you keep pipeline configuration persistent as you update images
      ]

      well_known_image_name = "ubuntu-24.04-g2/latest"
    }
  }
}
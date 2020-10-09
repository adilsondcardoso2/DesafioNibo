data "azurerm_client_config" "current" {}

locals {
  tags = {
      create_by    = data.azurerm_client_config.current.object_id
  }

  app_settings = {
        APPINSIGHTS_INSTRUMENTATIONKEY     = azurerm_application_insights.main.instrumentation_key
        WEBSITE_HTTPLOGGING_RETENTION_DAYS = "1"
        WEBSITE_LOAD_CERTIFICATES          = "*"
        WEBSITE_TIME_ZONE                  = "E. South America Standard Time"
        PORT                               = 80,
        SCM_SCRIPT_GENERATOR_ARGS          = "--node",
        NODE_ENV                           = "production"
  }
}

resource "random_string" "main" {
    length  = 4
    special = false
}

resource "azurerm_resource_group" "main" {
    name     = var.resourcegroup_name == "" ? upper(join("_", ["RG",random_string.main.result])) : upper(var.resourcegroup_name)
    location = var.location
    
    tags = local.tags
}

resource "azurerm_application_insights" "main" {
    name                = var.appinsights_name == "" ? lower(join("", ["appinsights", random_string.main.result])) : lower(var.appinsights_name)
	application_type    = "web"
	resource_group_name = azurerm_resource_group.main.name
	location            = var.location
    retention_in_days   = 90

	tags = local.tags
}

resource "azurerm_app_service_plan" "main" {
  name                = var.servicePlan_name == "" ? lower(join("", ["svcplan",random_string.main.result])) : lower(var.servicePlan_name)
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  kind                = "app"
  reserved            = false

  sku {
    tier = "Basic"
    size = "B1"
  }

  tags = local.tags

}

resource "azurerm_app_service" "main" {
  name                = var.appservice_name == "" ? lower(join("", ["webapp",random_string.main.result])) : lower(var.appservice_name)
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  app_service_plan_id = azurerm_app_service_plan.main.id
  https_only          = true

  site_config {
    always_on                = false
    dotnet_framework_version = "v4.0"
    cors {
      allowed_origins = var.list_cors
    }

    default_documents = var.default_documents
  }

  app_settings = merge(var.custom_settings, local.app_settings)

  dynamic "connection_string" {
      for_each = var.connection_list

      content {
          name  = connection_string.value["name"]
          type  = connection_string.value["type"]
          value = connection_string.value["value"]
      }
    }

  tags = local.tags
  
}
resource "azurerm_resource_group" "landingzone" {
  name     = "${var.project_name}-${var.environment}-rg-landingzone"
  location = var.location
}

resource "azurerm_virtual_network" "landingzone" {
  name                = "${var.project_name}-${var.environment}-vnet"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name

  address_space = ["10.100.0.0/16"]

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_subnet" "appgw" {
  name                 = "appgw-subnet"
  resource_group_name  = azurerm_resource_group.landingzone.name
  virtual_network_name = azurerm_virtual_network.landingzone.name

  address_prefixes = ["10.100.1.0/24"]
}
resource "azurerm_subnet" "aks" {
  name                 = "aks-subnet"
  resource_group_name  = azurerm_resource_group.landingzone.name
  virtual_network_name = azurerm_virtual_network.landingzone.name

  address_prefixes = ["10.100.2.0/24"]
}
resource "azurerm_subnet" "future" {
  name                 = "future-subnet"
  resource_group_name  = azurerm_resource_group.landingzone.name
  virtual_network_name = azurerm_virtual_network.landingzone.name

  address_prefixes = ["10.100.3.0/24"]
}

resource "azurerm_network_security_group" "aks" {
  name                = "${var.project_name}-${var.environment}-nsg-aks"
  location            = azurerm_resource_group.landingzone.location
  resource_group_name = azurerm_resource_group.landingzone.name

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "azurerm_subnet_network_security_group_association" "aks" {
  subnet_id                 = azurerm_subnet.aks.id
  network_security_group_id = azurerm_network_security_group.aks.id
}
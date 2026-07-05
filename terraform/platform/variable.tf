variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "acr_name" {
  type = string
}

variable "sku" {
  type = string
}
variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}
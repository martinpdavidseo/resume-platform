variable "location" {
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
variable "environment" {
  type = string
}
variable "project_name" {
  type = string
}
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}
variable "location" {
  description = "Azure region"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "github_token" {
  description = "GitHub Token"
  type        = string
  sensitive   = true
}

variable "organization_unit_id" {
  type = string
}

variable "trusted_account_id" {
  type = string
}

variable "account_name" {
  type = string
}

variable "account_owner" {
  type = string
}

variable "domain" {
  type = string
}

variable "subdomain" {
  type = string
}

variable "roles" {
  type = map(any)
}

variable "github_organisations" {
  type = list(string)
}

variable "full_repository_name" {
  type = string
}
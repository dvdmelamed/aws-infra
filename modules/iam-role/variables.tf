variable "name" {
  type = string
}

variable "enforce_mfa" {
  type    = bool
  default = true
}

variable "policy_access" {
  type    = string
}

variable "trusted_entity" {
  type = string
}

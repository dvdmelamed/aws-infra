variable "name" {
  type = string
}

variable "has_console_access" {
  type = bool
}

variable "pgp_key" {
  type = string
}

variable "groups" {
  type = list(string)
}

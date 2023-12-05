variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "sys" {
  type = string
}

variable "vmadmin_user_object_id" {
  type = string
}

variable "vmadmin_user_password" {
  type      = string
  sensitive = true
}

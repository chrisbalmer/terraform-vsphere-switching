variable "datacenter" {
  type = string
}

variable "name" {
  type        = string
  description = "Name of the distributed switch"
}

variable "hosts" {
  type = list(object(
    {
      name    = string
      devices = list(string)
    }
  ))
}

variable "port_groups" {
  default = []
}

variable "default_port_group" {
  type = object(
    {
      name               = string
      distributed_switch = string
      vlan               = number
      auto_expand        = bool
      type               = string
    }
  )

  default = {
    name               = "default"
    distributed_switch = "default"
    vlan               = 1
    auto_expand        = true
    type               = null
  }
}

variable "nioc" {
  type    = bool
  default = true
}

variable "ldo" {
  type    = string
  default = "both"
}

variable "datacenter" {
  type = string
}

variable "hosts" {
  type = list(string)
}

variable "distributed_switches" {
  default = []
}

variable "default_distributed_switch" {
  type = object(
    {
      name = string
    }
  )

  default = {
    name = "default"
  }
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



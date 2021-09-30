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
      name = string
      vlan = number
      vlan_ranges = list(object(
        {
          max_vlan = number
          min_vlan = number
        }
      ))
      auto_expand            = bool
      type                   = string
      reset                  = bool
      allow_forged_transmits = bool
      allow_mac_changes      = bool
      allow_promiscuous      = bool
      allowed_overrides = object(
        {
          block_ports     = bool
          traffic_shaping = bool
          resource_pool   = bool
          vlan            = bool
          uplink_teaming  = bool
          security_policy = bool
          netflow         = bool
          filtering       = bool
        }
      )
    }
  )

  default = {
    name                   = "default"
    vlan                   = null
    vlan_ranges            = []
    auto_expand            = true
    type                   = null
    reset                  = true
    allow_forged_transmits = false
    allow_mac_changes      = false
    allow_promiscuous      = false
    allowed_overrides = {
      block_ports     = true
      traffic_shaping = false
      resource_pool   = false
      vlan            = false
      uplink_teaming  = false
      security_policy = false
      netflow         = false
      filtering       = false
    }
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

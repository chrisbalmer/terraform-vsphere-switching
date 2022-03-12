locals {
  port_groups = { for pg in var.port_groups : pg.name => merge(var.default_port_group, pg) }
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_host" "host" {
  count         = length(var.hosts)
  name          = var.hosts[count.index].name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_distributed_virtual_switch" "ds" {
  name          = var.name
  datacenter_id = data.vsphere_datacenter.dc.id

  uplinks = ["uplink1", "uplink2", "uplink3", "uplink4"]

  dynamic "host" {
    for_each = var.hosts

    content {
      host_system_id = data.vsphere_host.host[host.key].id
      devices        = host.value.devices
    }
  }

  network_resource_control_enabled = var.nioc
  link_discovery_operation         = var.ldo
  version                          = var.ds_version
}

resource "vsphere_distributed_port_group" "pg" {
  for_each                        = local.port_groups
  name                            = each.value.name
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.ds.id

  vlan_id                                = each.value.vlan
  auto_expand                            = each.value.auto_expand
  type                                   = each.value.type
  port_config_reset_at_disconnect        = each.value.reset
  allow_forged_transmits                 = each.value.allow_forged_transmits
  allow_mac_changes                      = each.value.allow_mac_changes
  allow_promiscuous                      = each.value.allow_promiscuous
  block_override_allowed                 = each.value.allowed_overrides.block_ports
  netflow_override_allowed               = each.value.allowed_overrides.netflow
  network_resource_pool_override_allowed = each.value.allowed_overrides.resource_pool
  security_policy_override_allowed       = each.value.allowed_overrides.security_policy
  shaping_override_allowed               = each.value.allowed_overrides.traffic_shaping
  traffic_filter_override_allowed        = each.value.allowed_overrides.filtering
  uplink_teaming_override_allowed        = each.value.allowed_overrides.uplink_teaming
  vlan_override_allowed                  = each.value.allowed_overrides.vlan

  dynamic "vlan_range" {
    for_each = each.value.vlan_ranges

    content {
      min_vlan = vlan_range.value.min_vlan
      max_vlan = vlan_range.value.max_vlan
    }
  }
}

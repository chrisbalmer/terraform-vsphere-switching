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
}

resource "vsphere_distributed_port_group" "pg" {
  for_each                        = local.port_groups
  name                            = each.value.name
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.ds.id

  vlan_id     = each.value.vlan
  auto_expand = each.value.auto_expand
  type        = each.value.type
}

locals {
  distributed_switches = { for ds in var.distributed_switches : ds.name => merge(var.default_distributed_switch, ds) }
  port_groups          = { for pg in var.port_groups : pg.name => merge(var.default_port_group, pg) }
}

data "vsphere_datacenter" "dc" {
  name = var.datacenter
}

data "vsphere_host" "host" {
  count         = length(var.hosts)
  name          = var.hosts[count.index]
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_distributed_virtual_switch" "ds" {
  for_each      = local.distributed_switches
  name          = each.value.name
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_distributed_port_group" "pg" {
  for_each                        = local.port_groups
  name                            = each.value.name
  distributed_virtual_switch_uuid = vsphere_distributed_virtual_switch.ds[each.value.distributed_switch].id

  vlan_id     = each.value.vlan
  auto_expand = each.value.auto_expand
  type        = each.value.type
}

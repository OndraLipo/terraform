#output "vms" {
#  value = "${libvirt_domain.server.*}"
#}

output "ips" {
  value = "${libvirt_domain.server.*.network_interface.0.addresses}"
}

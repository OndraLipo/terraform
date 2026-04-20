output "network" {
  description = "Network interfaces on the host"
  value       = data.libvirt_domain_interface_addresses.interfaces
}

output "create_ansible_inventory" {
  value       = "python ../build-ans-inventory.py"
}
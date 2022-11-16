# variables
variable "hostname" { default = "dns" }
variable "domain" { default = "test.local" }
variable "memoryMB" { default = 1024*2 }
variable "cpu" { default = 2 }
variable "vms" { default = 1 }

# Defining qcow image
resource "libvirt_volume" "rocky9" {
  name = "rocky9"
  #source = "https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud.qcow2"
  source = "/kvm/iso/Rocky-9-GenericCloud-9.0-20220830.0.x86_64.qcow2"
}

resource "libvirt_volume" "volume" {
  name           = "${var.hostname}-${count.index}.${var.domain}.qcow2"
  base_volume_id = libvirt_volume.rocky9.id
  pool           = "disks"
  count          = "${var.vms}"
}

resource "libvirt_cloudinit_disk" "commoninit" {
  name = "${var.hostname}-${count.index}-cloudinit.iso"
  pool = "disks" # List storage pools using virsh pool-list
  user_data = data.template_file.user_data[count.index].rendered
  count = "${var.vms}"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.yaml")
  vars = {
    hostname = "${var.hostname}-${count.index}"
    fqdn = "${var.hostname}-${count.index}.${var.domain}"
  }
  count = "${var.vms}"
}

# Define KVM domain to create
resource "libvirt_domain" "rocky9" {
  name   = "${var.hostname}-${count.index}.${var.domain}"
  memory = "${var.memoryMB}"
  vcpu   = "${var.cpu}"

  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id  

  cpu {
    mode = "host-passthrough"
  }

  network_interface {
    network_name = "default" # List networks with virsh net-list
    wait_for_lease = true
  }

  disk {
    volume_id = element(libvirt_volume.volume.*.id, count.index)
  }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "vnc"
    listen_type = "address"
    autoport = true
  }

  count = "${var.vms}"

#  provisioner "remote-exec" {
#    inline = [
#      "echo 'useradd -m -G wheel ansible && echo ansible:redhat | chpasswd'"
#    ]
#  }
}

# Output Server IP
output "names" {
  value = "${libvirt_domain.rocky9.*.name}"
}
output "ips" {
  value = "${libvirt_domain.rocky9.*.network_interface.0.addresses.0}"
}
terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
}

resource "libvirt_volume" "volume" {
  count  = "${var.vms}"
  name   = count.index > 0 ? format("%s-%s.%s.qcow2", var.hostname, count.index + 1, var.domain) : format("%s.%s.qcow2", var.hostname, var.domain)
  pool   = "disks"
  source = lookup(var.images, var.os, "")
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "commoninit" {
#  name = "${var.hostname}-${count.index}-cloudinit.iso"
  name = count.index > 0 ? format("%s-%s.%s-cloudinit.iso", var.hostname, count.index + 1, var.domain) : format("%s.%s-cloudinit.iso", var.hostname, var.domain)
  pool = "disks" # List storage pools using virsh pool-list
  user_data = data.template_file.user_data[count.index].rendered
  count = "${var.vms}"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud-init.yaml")
  vars = {
    #hostname = "${var.hostname}-${count.index}"
    #fqdn = "${var.hostname}-${count.index}.${var.domain}"  
    hostname = count.index > 0 ? format("%s-%s", var.hostname, count.index + 1) : format("%s", var.hostname)
    fqdn = count.index > 0 ? format("%s-%s.%s", var.hostname, count.index + 1, var.domain) : format("%s.%s", var.hostname, var.domain)
    rh_subscription = var.rh_subscription
  }
  count = "${var.vms}"
}

# Define KVM domain to create
resource "libvirt_domain" "server" {
  name   = count.index > 0 ? format("%s-%s.%s", var.hostname, count.index + 1, var.domain) : format("%s.%s", var.hostname, var.domain)
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

# generate inventory file for Ansible
#resource "local_file" "hosts_cfg" {
#  content = templatefile("${path.module}/hosts.tpl",
#    {
#      all = libvirt_domain.server.*.network_interface.0.addresses
#    }
#  )
#  filename = "hosts.cfg"
#}

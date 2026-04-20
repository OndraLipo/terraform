terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}
provider "proxmox" {
  endpoint = "${var.endpoint}"
  username = "${var.username}"
  password = "${var.password}"
  insecure = true
}

resource "proxmox_virtual_environment_vm" "server" {
  name        = "${var.hostname}.${var.domain}"
  description = "${var.hostname}.${var.domain}\n root:redhat"
  pool_id = "${var.pool}"
  node_name = "${var.node}"
  started = "${var.started}"
#  tags        = ["pve2sc", "pve3sc"]
#  vm_id     = 4321

#  agent {
#    enabled = true
#  }

  cpu {
    type = lookup(var.cpu_type, var.os, "")
    cores = "${var.cpu}"
  }

  memory {
    dedicated = "${var.memoryMB}"
  }

  operating_system {
    type = "l26"
  }

  scsi_hardware = "virtio-scsi-single"

  disk {
    datastore_id = "VMs_1"
    size = 50
#    file_id      = proxmox_virtual_environment_file.cloud_image.id
    interface    = "scsi0"
    iothread = true
    cache   =   "writeback"
  }

  cdrom {
    enabled = true
    file_id = lookup(var.images, var.os, "")
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = 360
  }

  initialization {
    datastore_id = "VMs_1"

    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      password = "redhat"
      username = "ansible"
    }

    #user_data_file_id = proxmox_virtual_environment_file.cloud_config.id
  }
}

#resource "proxmox_virtual_environment_file" "cloud_image" {
#  content_type = "iso"
#  datastore_id = "VMs_1"
#  node_name = "UNIX-DL380-G9-PVE3SC"
  
#  source_file {
    #path = "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2"
#    path = "/kvm/iso/rhel-9.2-x86_64-kvm.qcow2"
#  }
#}

#resource "random_password" "ubuntu_vm_password" {
#  length           = 16
#  override_special = "_%@"
#  special          = true
#}

#resource "tls_private_key" "ubuntu_vm_key" {
#  algorithm = "RSA"
#  rsa_bits  = 2048
#}

#output "ubuntu_vm_password" {
#  value     = random_password.ubuntu_vm_password.result
#  sensitive = true
#}

#output "ubuntu_vm_private_key" {
#  value     = tls_private_key.ubuntu_vm_key.private_key_pem
#  sensitive = true
#}

#output "ubuntu_vm_public_key" {
#  value = tls_private_key.ubuntu_vm_key.public_key_openssh
#}


#data "proxmox_virtual_environment_vms" "vms" {
#  node_name      = "UNIX-DL380-G9-PVE3SC"
#}

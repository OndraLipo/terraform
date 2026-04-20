#Docs: https://github.com/dmacvicar/terraform-provider-libvirt/tree/main/docs

terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}

provider "libvirt" {
  uri = "qemu:///system"
  #uri = "qemu+sshcmd://lipinond@192.168.2.213/session?keyfile=/home/lipinond/.ssh/id_rsa"
  #uri = "qemu:///session?socket=/run/user/1000/libvirt/virtqemud-sock"
}

# Generate cloud init ISO from variables
data "template_file" "user_data" {
  template = templatefile("${path.module}/cloud-init/user-data.yaml", {
    hostname = count.index > 0 ? format("%s-%s", var.hostname, count.index + 1) : format("%s", var.hostname),
    fqdn = count.index > 0 ? format("%s-%s.%s", var.hostname, count.index + 1, var.domain) : format("%s.%s", var.hostname, var.domain),
    rh_subscription = var.rh_subscription
    sles_subscription = var.sles_subscription
  } )
  count = "${var.vms}"
}

data "template_file" "meta_data" {
  template = templatefile("${path.module}/cloud-init/meta-data.yaml", {
    hostname = count.index > 0 ? format("%s-%s", var.hostname, count.index + 1) : format("%s", var.hostname),
  } )
  count = "${var.vms}"
}

resource "libvirt_cloudinit_disk" "init" {
  name = count.index > 0 ? format("%s-%s.%s-cloudinit.iso", var.hostname, count.index + 1, var.domain) : format("%s.%s-cloudinit.iso", var.hostname, var.domain)
  user_data = data.template_file.user_data[count.index].rendered
  meta_data = data.template_file.meta_data[count.index].rendered
  count = "${var.vms}"
}

# Disks (volumes)
## volume = standard disk
## cloudinit = cloud init cd

resource "libvirt_volume" "volume" {
  count  = "${var.vms}"
  name   = count.index > 0 ? format("%s-%s.%s.qcow2", var.hostname, count.index + 1, var.domain) : format("%s.%s.qcow2", var.hostname, var.domain)
  pool   = "disks"

  create = {
    content = {
      url = lookup(var.images, var.os, "")
    }
  }
}

resource "libvirt_volume" "cloudinit" {
  count  = "${var.vms}"
  name   = count.index > 0 ? format("%s-%s.%s-cloudinit.iso", var.hostname, count.index + 1, var.domain) : format("%s.%s-cloudinit.iso", var.hostname, var.domain)
  pool   = "disks"

  create = {
    content = {
      url = libvirt_cloudinit_disk.init[count.index].path
    }
  }
}

# Define KVM domain to create
resource "libvirt_domain" "server" {
  name   = count.index > 0 ? format("%s-%s.%s", var.hostname, count.index + 1, var.domain) : format("%s.%s", var.hostname, var.domain)
  memory = "${var.memoryMB}"
  memory_unit   = "MiB"
  vcpu   = "${var.cpu}"
  running = "${var.running}"
  type   = "kvm"

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "q35"
    kernel_args  = "console=ttyS0,115200n8"
  }

  features = {
    pae = "true"
    acpi = "true"
    apic = {
    }
  }

  cpu = {
    mode = "host-passthrough"
  }
  devices = {
    interfaces = [
      {
        model = {
          type = "virtio"
        }
        source = {
          network = {
            network = "default"
          }
        }
        wait_for_ip = {
          timeout = 60  # seconds
          source  = "lease" # possible options: any, agent, lease
        }
      }
    ]
    disks = [
      {
        source = {
          file = {
            file = element(libvirt_volume.volume.*.id, count.index)
          }
        }
        driver = {
          type = "qcow2"
          discard = "unmap"
        }
        target = {
          dev = "sda"
          bus = "sata"
        }
      },
      {
        source = {
          file = {
            file = element(libvirt_volume.cloudinit.*.id, count.index)
          }
        }
        target = {
          dev = "sdb"
          bus = "sata"
        }
        device = "cdrom"
      }
    ]
    consoles = [
      {
        type = "pty"
        target = {
          #port = "0"
          type = "serial"
        }
      }
    ]
    channels = [
      {
        source = {
          unix = {
            mode = "bind"
          }
        }
        type = "unix"
        target = {
          virt_io = {
            name = "org.qemu.guest_agent.0"
          }
        }
      }
    ]
    rngs = [
      {
        model = "virtio"
        backend = {
          random = "/dev/urandom"
        }
      }
    ]
  }
  count = "${var.vms}"

  provisioner "local-exec" {
    when    = destroy
    on_failure = continue
    command = "ansible-playbook -i inventory.ini ../modules/libvirt/deregister.yml"
  }
}

data "libvirt_domain_interface_addresses" "interfaces" {
  domain = element(libvirt_domain.server.*.name, count.index)
  count = "${var.vms}"
}

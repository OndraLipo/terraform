# variables

#Proxmox environment
variable "endpoint" { default = "<proxmox url>" }
variable "username" { default = "<username>" }
variable "password" { default = "<password>" }
variable "pool" { default = "<pool where to create VMs>" }
variable "node" { default = "<default node>" }

#VMs
variable "hostname" { default = "server" }
variable "domain" { default = "test.local" }
variable "memoryMB" { default = 1024*2 }
variable "cpu" { default = 2 }
variable "vms" { default = 1 }
variable "os" { default = "rhel7" }
variable "started" { default = true }
variable "rh_subscription" { default = false }

variable "images" {
    type = map(string)
    default = {
        "rhel9" = "ISO:iso/Rocky-9.2-x86_64-minimal.iso"
        "rhel8" = "/kvm/iso/rhel-8.8-x86_64-kvm.qcow2"
        "rhel7" = "ISO:iso/rhel7.9-custom.iso"
        "rhel6" = "/kvm/iso/rhel-server-6.10-update-11-x86_64-kvm.qcow2"
    }
}

variable "cpu_type" {
    type = map(string)
    default = {
        "rhel9" = "custom-rhel9"
        "rhel8" = "qemu64"
        "rhel7" = "qemu64"
        "rhel6" = "qemu64"
    }
}
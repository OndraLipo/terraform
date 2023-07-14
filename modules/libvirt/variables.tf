# variables
variable "hostname" { default = "server" }
variable "domain" { default = "test.local" }
variable "memoryMB" { default = 1024*2 }
variable "cpu" { default = 2 }
variable "vms" { default = 1 }
variable "os" { default = "rhel9" }
variable "rh_subscription" { default = false }

variable "images" {
    type = map(string)
    default = {
        "rhel9" = "/kvm/iso/rhel-9.2-x86_64-kvm.qcow2"
        "rhel8" = "/kvm/iso/rhel-8.8-x86_64-kvm.qcow2"
        "rhel7" = "/kvm/iso/rhel-server-7.9-update-12-x86_64-kvm.qcow2"
        "rhel6" = "/kvm/iso/rhel-server-6.10-update-11-x86_64-kvm.qcow2"
    }
}

#variable "iso" { default = "/kvm/iso/Rocky-9-GenericCloud-9.0-20220830.0.x86_64.qcow2" }


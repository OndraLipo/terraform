# variables
variable "hostname" { default = "server" }
variable "domain" { default = "test.local" }
variable "memoryMB" { default = 1024*2 }
variable "cpu" { default = 2 }
variable "vms" { default = 1 }
variable "os" { default = "rhel9" }
variable "rh_subscription" { default = false }
variable "sles_subscription" { default = false }
variable "running" { default = true }

variable "images" {
    type = map(string)
    default = {
        "rhel10" = "/kvm/iso/rhel-10.1-x86_64-kvm.qcow2"
        "rhel95" = "/kvm/iso/rhel-9.5-x86_64-kvm.qcow2"
        "rhel97" = "/kvm/iso/rhel-9.7-x86_64-kvm.qcow2"
        "rhel94" = "/kvm/iso/rhel-9.4-x86_64-kvm.qcow2"
        "rhel8" = "/kvm/iso/rhel-8.8-x86_64-kvm.qcow2"
        "rhel7" = "/kvm/iso/rhel-server-7.9-update-12-x86_64-kvm.qcow2"
        "rhel6" = "/kvm/iso/rhel-server-6.10-update-11-x86_64-kvm.qcow2"
        "centos9" = "/kvm/iso/CentOS-Stream-GenericCloud-9-20230828.0.x86_64.qcow2"
        "sles15sp5" = "/kvm/iso/SLES15-SP5-Minimal-VM.x86_64-Cloud-GM.qcow2"
        "sles15sp6" = "/kvm/iso/SLES15-SP6-Minimal-VM.x86_64-Cloud-QU2.qcow2"
        "sles16" = "/kvm/iso/SLES-16.0-Minimal-VM.x86_64-Cloud-QU0.qcow2"
        "fedora" = "/kvm/iso/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2"
        "fedora-server" = "/kvm/iso/Fedora-Server-KVM-40-1.14.x86_64.qcow2"
        "rocky10" = "/kvm/iso/Rocky-10-GenericCloud-Base.latest.x86_64.qcow2"
        "rocky9" = "/kvm/iso/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
        "ubuntu24" = "/kvm/iso/noble-server-cloudimg-amd64.img"
    }
}

#variable "iso" { default = "/kvm/iso/Rocky-9-GenericCloud-9.0-20220830.0.x86_64.qcow2" }

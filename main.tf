module "rhel9" {
   source = "./modules/libvirt"
   hostname     = "rhel9"
   domain       = "test.local"
#   running = false
   cpu    = 2
   memoryMB  = 2048
   os = "rhel9"  
#  iso = "/kvm/iso/rhel-9.2-x86_64-kvm.qcow2"
   vms = 1
#   network = "default"
   rh_subscription = true
}

module "rhel8" {
   source = "./modules/libvirt"
   hostname     = "rhel8"
   domain       = "test.local"
   cpu    = 2
   memoryMB  = 2048
   os = "rhel8"  
   vms = 1
   rh_subscription = true
}

module "rhel7" {
   source = "./modules/libvirt"
   hostname     = "rhel7"
   domain       = "test.local"
   cpu    = 2
   memoryMB  = 2048
   os = "rhel7"  
   vms = 1
   rh_subscription = true
}

module "rhel6" {
   source = "./modules/libvirt"
   hostname     = "rhel6"
   domain       = "test.local"
   cpu    = 2
   memoryMB  = 2048
   os = "rhel6"  
   vms = 1
   rh_subscription = true
}
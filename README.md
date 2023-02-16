# Terraform on Fedora and libvirt
1. Install terraform

       https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
       dnf install terraform

2. Ensure libvirtd and all the sockets are running, especially: libvirt.socket (/var/run/libvirt/libvirt-sock)

3. Configure polkit so standard user is able to comunicate with qemu without sudo

       usermod --append --groups libvirt `whoami`

4. Initialize terraform

       terraform init

5. apply and destroy

       terraform apply
       terraform destroy

6. pass variables

       terraform apply -var='hostname=somehost' -var='vms=3' -var='iso=""'

7. variable files

       hostname = "app"
       domain = "name.local"
       memoryMB = 1024*2 
       cpu = 2
       vms = 3
       iso = "/kvm/iso/Rocky-9-GenericCloud-9.0-20220830.0.x86_64.qcow2"

8. use workspaces

       terraform workspace new <name>
       terraform workspace select <name>
       terraform apply -var-file=<file>

## Files
- main.tf
- new-vms.auto.tfvars
- libvirt_resources.tf
- cloud-init.yaml

## Links
https://github.com/dmacvicar/terraform-provider-libvirt/tree/main/examples/
https://cloudinit.readthedocs.io/en/latest/

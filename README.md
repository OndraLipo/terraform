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

## Files
- main.tf
- rocky9_multi.tf
- cloud-init.yaml

## Links
https://github.com/dmacvicar/terraform-provider-libvirt/tree/main/examples/
https://cloudinit.readthedocs.io/en/latest/

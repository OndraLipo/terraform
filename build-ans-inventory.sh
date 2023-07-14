#!/bin/bash
#build-ans-inventory.sh

INVENTORY=inventory.yaml

#Prepare header
cat <<EOT > $INVENTORY
[all:vars]
ansible_user=ansible
ansible_password=redhat

[all]
EOT

# Export IPs from virsh
for i in $(sudo virsh list --name | awk -F"." '{ print $1}'); do sudo virsh -q net-dhcp-leases default | grep -w "$i " ; done | awk '{ print $6" "$5}' | grep -v "^-"| awk 'NF' | sed 's/\/24//' | awk '{ print $1" ansible_host="$2}' >> $INVENTORY
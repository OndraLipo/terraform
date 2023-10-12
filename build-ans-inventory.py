import json

pathtostate = input("Path to tfstate file: ")
#tfstate = open('libvirt-environments/terraform.tfstate')
tfstate = open(pathtostate)
data = json.load(tfstate)

with open('inventory.ini', 'w') as inventory:

    header = ['[all:vars]\n',
              'ansible_user=ansible\n',
              'ansible_password=redhat\n\n',
              '[all]\n'
    ]

    inventory.writelines(header)

    for resource in data['resources']:
        for instance in resource['instances']:
            if resource['type'] == 'libvirt_domain':
                hostname = instance['attributes'].get('name')
                ip = instance['attributes']['network_interface'][0]['addresses'][0]
                print(f"{hostname} ansible_host={ip}", file=inventory)
 
tfstate.close()
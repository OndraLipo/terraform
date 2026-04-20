import json
import os

current_dir = os.getcwd()
state_file = os.path.join(current_dir,'terraform.tfstate')
output_file = os.path.join(current_dir,'inventory.ini')

while not os.path.exists(state_file):
    time.sleep(1)

if os.path.isfile(state_file):

    tfstate = open(state_file)
    data = json.load(tfstate)

    with open(output_file, 'w') as inventory:

        header = ['[all:vars]\n',
                'ansible_user=ansible\n',
                'ansible_password=redhat\n\n',
                '[all]\n'
        ]

        inventory.writelines(header)

        for resource in data['resources']:
            for instance in resource['instances']:
                if resource['type'] == 'libvirt_domain_interface_addresses':
                    hostname = instance['attributes'].get('domain')
                    ip = instance['attributes']['interfaces'][0]['addrs'][0]['addr']
                    print(f"{hostname} ansible_host={ip}", file=inventory)
    
    tfstate.close()
#!/bin/bash

# ssh-keygen -t rsa -b 2048 -f ssh_keys/api-service-document-cloudfront
# ssh-keygen -t rsa -b 2048 -f ssh_keys/bastion_host
# ssh-keygen -t rsa -b 2048 -f ssh_keys/ansible_server
# ssh-keygen -t rsa -b 2048 -f ssh_keys/ansible_hosts

terraform apply

terraform output -json > output.json
#! /bin/bash
touch /etc/profile.d/instance_variables.sh
echo export INSTANCE_TYPE="primary-api-service" > /etc/profile.d/instance_variables.sh
sudo apt-get update

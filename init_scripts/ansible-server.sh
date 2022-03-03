#! /bin/bash
touch /etc/profile.d/instance_variables.sh
echo export INSTANCE_TYPE="ansible-server" > /etc/profile.d/instance_variables.sh

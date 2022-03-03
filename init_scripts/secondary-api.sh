#! /bin/bash
touch /etc/profile.d/instance_variables.sh
echo export INSTANCE_TYPE="secondary-api-service" > /etc/profile.d/instance_variables.sh

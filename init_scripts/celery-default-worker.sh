#! /bin/bash
touch /etc/profile.d/instance_variables.sh
echo export INSTANCE_TYPE="celery-default-worker" > /etc/profile.d/instance_variables.sh
sudo apt-get update

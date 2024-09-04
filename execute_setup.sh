#!/bin/bash

# Read the list of hosts from /etc/hosts
hosts=$(awk '{print $1}' /etc/hosts | grep -E -o '^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')

# Loop through each host
for host in $hosts
do
    echo "Connecting to $host"
    ssh devops@$host 'bash -s' < ./setup.sh
done

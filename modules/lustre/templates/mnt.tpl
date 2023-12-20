#!/bin/bash
set -e

# PARAMETERS
FSX_DNS_NAME=${dns_name}
FSX_MOUNT_NAME=${mnt_name}

# First, we need to install the lustre libraries
# this command is dependent on current running Amazon Linux versions
CURR_VERSION=$(cat /etc/os-release)
if [[ $CURR_VERSION == *$"http://aws.amazon.com/amazon-linux-ami/"* ]]; then
	sudo yum install -y lustre-client
else
	sudo amazon-linux-extras install -y lustre
fi

# Now we can create the mount point and mount the file system
# And we make sure we have the appropriate access to the directory
sudo mkdir -p /fsx
sudo mount -t lustre -o noatime,flock $FSX_DNS_NAME@tcp:/$FSX_MOUNT_NAME /fsx
sudo chmod go+rw /fsx

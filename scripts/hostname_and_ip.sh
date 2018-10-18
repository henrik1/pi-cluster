#!/bin/sh

# Script to setup ip and dns on a node

# MASTER
# $ sh hostname_and_ip.sh k8s-master 192.168.1.100 192.168.1.1

# WORKERS
# $ sh hostname_and_ip.sh k8s-worker-01 192.168.1.101 192.168.1.1
# $ sh hostname_and_ip.sh k8s-worker-02 192.168.1.102 192.168.1.1
# $ sh hostname_and_ip.sh k8s-worker-03 192.168.1.103 192.168.1.1

# REBOOT PIS

hostname=$1
ip=$2 # should be of format: 192.168.1.100
dns=$3 # should be of format: 192.168.1.1


# Change the hostname
sudo hostnamectl --transient set-hostname $hostname
sudo hostnamectl --static set-hostname $hostname
sudo hostnamectl --pretty set-hostname $hostname
sudo sed -i s/raspberrypi/$hostname/g /etc/hosts

# Set the static ip

sudo cat <<EOT >> /etc/dhcpcd.conf
interface eth0
static ip_address=$ip/24
static routers=$dns
static domain_name_servers=$dns
EOT

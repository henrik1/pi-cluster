# STEP BY STEP GUIDE TO SETUP PI KUBERNETES CLUSTER

## Install OS
From your local computer install an OS eg. Raspbian OS which can be found here:
```
https://www.raspberrypi.org/downloads/raspbian/
```

## Enable ssh
Before you unmount the SD card run the following command to enable ssh on the Raspbian OS
```
$ touch /Volumes/boot/ssh
```

## Test ssh
Insert the SD cards into the PIs and boot up. Test that ssh is working by:
```
$ ssh pi@raspberrypi.local
```

## Copy setup scripts
Copy the setup scripts from ./scripts to the Raspberry's

## Setup ip and dns
Ssh into the nodes and run the following scripts

### Master node
```
$ sh hostname_and_ip.sh k8s-master 192.168.1.100 192.168.1.1
```

### Worker node 1
```
$ sh hostname_and_ip.sh k8s-worker-01 192.168.1.101 192.168.1.1
```

### Worker node 2
```
$ sh hostname_and_ip.sh k8s-worker-02 192.168.1.102 192.168.1.1
```

Repeat the above pattern if you have more workers

From your local computer try to ssh into the nodes by using the dns just configured
```
$ ssh pi@k8s-master.local (or k8s-worker-01.local etc.)
```

## Setup docker, kubeadm etc on the nodes
```
$ sh node_setup.sh
```

## Setup master node
```
$ sudo kubeadm init --config master_node_config.yaml
```

This should take a couple of minutes. You should see something like below if the operation was successful.

```
Your Kubernetes master has initialized successfully!
To start using your cluster, you need to run the following as a regular user:

mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

$ kubeadm join --token TOKEN 192.168.1.100:6443 --discovery-token-ca-cert-hash HASH

```

## Set worker nodes
Follow the instructions above to setup the kubernetes workers.

## Terraform kubernetes cluster

#!/bin/bash

set -eou pipefail

export PATH=$PATH:/usr/bin

apt-get update
apt-get upgrade -y

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' > /etc/apt/sources.list.d/kubernetes.list
apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce kubelet kubeadm kubectl kubernetes-cni

useradd -s /bin/bash -mU -G sudo,docker matt; echo "matt:$1" | chpasswd
mkdir -p /home/matt/.ssh; cp /root/.ssh/authorized_keys /home/matt/.ssh/authorized_keys
chown matt /home/matt/.ssh/authorized_keys

echo 'beta.holmescode.com' > /etc/hostname

kubeadm init \
    --apiserver-cert-extra-sans beta.holmescode.com \
    --pod-network-cidr=10.244.0.0/16

mkdir -p /home/matt/.kube
cp -i /etc/kubernetes/admin.conf /home/matt/.kube/config
chown $(id -u matt):$(id -g matt) /home/matt/.kube/config

su - matt
cd $HOME
kubectl taint nodes --all node-role.kubernetes.io/master-
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

git clone https://github.com/holmescode/server
cd server
git checkout beta

#!/bin/bash

# ubuntu 22.04 LTS version

# Install Start
echo "################# Install k8s start #################"
echo " "

# 1. Delete k8s
echo "################# Delete k8s #################"
echo " "
apt-get purge kubeadm kubectl kubelet kubernetes-cni kube*
apt-get -y autoremove
echo " "

# 2. Swap Off
echo "################# Swap Off #################"
echo " "
swapoff -a
echo 0 > /proc/sys/vm/swappiness
sed -e '/swap/ s/^#*/#/' -i /etc/fstab
echo " "

# 3. Install Package
echo "################# Install Package #################"
echo " "
apt-get update
apt-get install -y apt-transport-https ca-certificates curl gpg
echo " "

# 4. Create GPG Key Directory and Add k8s GPG Key
echo "################# Add GPG Key #################"
echo " "
mkdir -p -m 755 /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo " "

# 5. Add K8s Repo (1.29)
echo "################# Add K8s Repo #################"
echo " "
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
echo " "

# 6. Install K8s (1.29)
echo "################# Install K8s #################"
echo " "
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl
echo " "

# 7. K8s Version Fixed(no Update)
echo "################# Install K8s #################"
echo " "
apt-mark hold kubelet kubeadm kubectl
echo " "

# 8. containerd restart
echo "################# ontainerd restart #################"
echo " "
rm /etc/containerd/config.toml
systemctl restart containerd
echo " "

# Install Finish
echo "################# Install k8s finish #################"
echo " "
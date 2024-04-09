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

# 3. Download Docker Package (1.20.1)
echo "################# Download k8s Package #################"
echo " "
wget https://packages.cloud.google.com/apt/pool/cri-tools_1.13.0-01_amd64_4ff4588f5589826775f4a3bebd95aec5b9fb591ba8fb89a62845ffa8efe8cf22.deb
wget https://packages.cloud.google.com/apt/pool/kubeadm_1.20.1-00_amd64_7cd8d4021bb251862b755ed9c240091a532b89e6c796d58c3fdea7c9a72b878f.deb
wget https://packages.cloud.google.com/apt/pool/kubectl_1.20.1-00_amd64_b927311062e6a4610d9ac3bc8560457ab23fbd697a3052c394a1d7cc9e46a17d.deb
wget https://packages.cloud.google.com/apt/pool/kubelet_1.20.1-00_amd64_560a52294b8b339e0ca8ddbc480218e93ebb01daef0446887803815bcd0c41eb.deb
wget https://packages.cloud.google.com/apt/pool/kubernetes-cni_0.8.7-00_amd64_ca2303ea0eecadf379c65bad855f9ad7c95c16502c0e7b3d50edcb53403c500f.deb
echo " "

# 4. Install Docker Package
echo "################# Install k8s Package #################"
echo " "
apt-get install socat conntrack ebtables
dpkg --install ./kubernetes-cni_0.8.7-00_amd64_ca2303ea0eecadf379c65bad855f9ad7c95c16502c0e7b3d50edcb53403c500f.deb
dpkg --install ./kubelet_1.20.1-00_amd64_560a52294b8b339e0ca8ddbc480218e93ebb01daef0446887803815bcd0c41eb.deb
dpkg --install ./cri-tools_1.13.0-01_amd64_4ff4588f5589826775f4a3bebd95aec5b9fb591ba8fb89a62845ffa8efe8cf22.deb
dpkg --install ./kubectl_1.20.1-00_amd64_b927311062e6a4610d9ac3bc8560457ab23fbd697a3052c394a1d7cc9e46a17d.deb
dpkg --install ./kubeadm_1.20.1-00_amd64_7cd8d4021bb251862b755ed9c240091a532b89e6c796d58c3fdea7c9a72b878f.deb
echo " "

# Install Finish
echo "################# Install k8s finish #################"
echo " "

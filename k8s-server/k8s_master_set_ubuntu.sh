#!/bin/bash

# ubuntu 22.04 LTS version

# k8s Master Node Set Start
echo "################# k8s Master Node Set Start #################"
echo " "

# 1. Init
echo "################# k8s Master Node Init #################"
echo " "
loadbalance = ''
read -p "Master Node Cluster Set? (y/n) " yn
case $yn in
        [yY] ) echo -n "Load Balancer IP or HOST : "
               read -e loadbalance
               read -p "Check Load Balancer [$loadbalance]? (y/n) " yn
               case $yn in
                 [nN] ) exit;;
               esac
               kubeadm init --control-plane-endpoint=$loadbalance:6443 --pod-network-cidr=10.244.0.0/16 --upload-certs;;
        [nN] ) kubeadm init --pod-network-cidr=10.244.0.0/16;;
esac
echo " "

# 2. Enable kubectl in your user account
echo "################# Enable Account #################"
echo " "
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo " "

# 3. Install Flannel
echo "################# Install Flannel #################"
echo " "
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
echo " "

# Master Clustering 후 Worker 기능 사용시에 주석 해제
# 4. taint disabled
# echo "################# Taint Disabled #################"
# echo " "
# kubectl taint nodes --all node-role.kubernetes.io/master-
# echo " "

# k8s Master Node Set Finish
echo "################# k8s Master Node Set finish #################"
echo " "

# 참고 자료
# https://tech.cloudmt.co.kr/2022/06/27/k8s-highly-available-clusters/
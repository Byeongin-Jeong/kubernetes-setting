#!/bin/bash

# ubuntu 22.04 LTS version
# 설치 전 로드밸런스 대상 서버의 HostName, IP 변경할 것
# Worker node만 있을 경우 worker Hostname과 IP만 등록
# ex) server {hostname} {ip}:{port} check
#     server k8s-test-m1 10.0.1.223:6443 check
#     server k8s-test-m2 10.0.1.224:6443 check
#     server k8s-test-m3 10.0.1.225:6443 check

# Install Start
echo "################# Install Haproxy start #################"
echo " "

# 1. Install Haproxy
echo "################# Install Haproxy #################"
echo " "
apt-get update && apt-get install -y haproxy
echo " "

# 2. Set Haproxy.cfg
echo "################# Set Haproxy.cfg #################"
echo " "
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg-org

echo "vi /etc/haproxy/haproxy.cfg"
echo " "
cat <<EOF >> /etc/haproxy/haproxy.cfg
listen stats
        bind *:9000
        mode  http
        option dontlog-normal
        stats enable
        stats realm Haproxy\ Statistics
        stats uri /haproxy
        http-request use-service prometheus-exporter if { path /metrics }
frontend kubernetes-master-lb
        bind 0.0.0.0:6443
        option tcplog
        mode tcp
        default_backend kubernetes-master-nodes
frontend kubernetes-worker-lb
        bind *:80 # 포트 설정
        mode http
        log  global
        option httplog
        default_backend http_backend_nginx_controllers #기본 backend 설정
backend kubernetes-master-nodes
        mode tcp
        balance roundrobin
        option tcp-check
        option tcplog
        server k8s-master 192.168.10.100:6443 check
backend http_backend_nginx_controllers
        balance roundrobin
        mode http
        option tcp-check
        server k8s-worker-1 192.168.10.101:30143 check
        server k8s-worker-2 192.168.10.102:30143 check
        server k8s-worker-3 192.168.10.103:30143 check
EOF
echo " "

# 3. Haproxy Service Restart and Enable
echo "################# Haproxy Service Restart and Enable #################"
echo " "
systemctl restart haproxy
systemctl enable haproxy
echo " "

# Install Haproxy Finish
echo "################# Install Haproxy finish #################"
echo " "
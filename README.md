# k8s-setting



### 1. k8s 서버 세팅

#### 1) docker 설치
```
sudo ./dockerCE_install_ubuntu.sh
```
#### 2) k8s 설치
```
sudo ./k8s_common_install_ubuntu.sh
```
#### 3) k8s master 설정 및 클러스터 구성
- Master를 worker mode로 사용시 주석 해제 또는 명령어 실행\
**kubectl taint nodes --all node-role.kubernetes.io/master-**
```
sudo ./k8s_master_set_ubuntu.sh
...

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
#### 4) worker Node Join
- master 설정 후 출력된 토큰 정보를 입력
- master 클러스터링시 나오는 결과는 조금 다를 수 있다.
```
ex) sudo kubeadm join 192.168.102.111:6443 --token uifaqn.c8lsjrqts493mw7u \
    --discovery-token-ca-cert-hash sha256:2f3bd4a77fe040d1211d1ba684885ec0a8905160fc5cd5b6296525bf087ef7cc
```

---------------------------------------
### 2. k8s 컨테이터 설정
#### 1. namespace 구성
```
sudo kubectl apply -f namespace.yaml
```
#### 2. ingress nginx 구성
```
sudo kubectl apply -f ingress-nginx.yaml
```
#### 3. rabbitmq 구성
- rabbitmq의 경우 statefulset or deployment 둘 중에 하나 사용
```
# 서비스 종료시 데이터 유지 가능. 단, 볼륨 마운트 해야됨.
sudo kubectl apply -f rabbitmq-statefulset.yaml

# 서비스 종료시 데이터 유지 불가능
sudo kubectl apply -f rabbitmq-deployment.yaml

sudo kubectl apply -f rabbitmq-service.yaml
sudo kubectl apply -f rabbitmq-ingress.yaml
```

---------------------------------------
### 3. Gitlab Docker Private Repogitory 구성
#### 1. Master, worker Node에 insecure-registries 등록
- gitlab IP 또는 도메인 등록
```
sudo vi /etc/docker/daemon.json

{
    "insecure-registries": ["localhost:8001"],
    "log-driver": "json-file",
    "log-opts": {
      "max-size": "10m",
      "max-file": "10"
    }
}
```
#### 2. docker login
```
sudo docker login <IP>:<PORT>
IP, PW 입력 후 로그인
```
#### 3. k8s secret 생성 (Gitlab을 docker repo로 사용 할 경우의 예)
#### ※ 3가지 방법으로 secret 생성 가능
- service 명은 gitlab-secret로 지정
1. dockerconfigjson을 이용해서 생성하기(많이 사용함)
```
sudo kubectl create secret generic gitlab-secret --from-file=.dockerconfigjson=/root/.docker/config.json  --type=kubernetes.io/dockerconfigjson -n=k8s-test
```
2. docker repository IP:PORT, ID, PW로 생성하기
```
sudo kubectl create secret docker-registry gitlab-secret -n=k8s-test --docker-server=<ip>:<port> --docker-username=<id> --docker-password=<password>
```
3. gitlab-secret.yaml 파일로 구성시, config.json 파일을 base64로 변환하여 내용 등록 후 생성가능

---------------------------------------
### 4. Proxy 서버 세팅
haproxy.sh 파일에 K8s Worker Node IP, HostName, Gitlab 도메인 변경
- 외부 통신의 경우 Worker Node port의 경우 nginx-controller 외부 포트(30234) 정보를 입력해준다.
```
sudo kubectl get service -A
ex) ingress-nginx-controller  NodePort  10.107.195.56   <none>    80:30234
```
```
haproxy.sh
```
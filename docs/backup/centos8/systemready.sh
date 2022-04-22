##install some tools
dnf install net-tools -y
dnf install vim -y

##install disalbe firewall and selinux
systemctl stop firewalld
systemctl disalbe firewalld
setenforce 0

##install docker, go, kind, kubectl
dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo
dnf install docker-ce --nobest -y
systemctl start docker
systemctl enable docker
yum module -y install go-toolset
dnf install git -y
GO111MODULE="on" go get sigs.k8s.io/kind@v0.11.1
cp /root/go/bin/kind /usr/bin/kind
curl -LO https://dl.k8s.io/release/v1.18.0/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/bin/kubectl
mkdir -p ~/.kube
dnf install wget -y

##change docker volume location
echo -e '{\n"data-root": "/tmp/"\n}' >> /etc/docker/daemon.json
systemctl restart docker

sleep 3
##install cilium
##curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/download/v0.9.3/cilium-linux-amd64.tar.gz
##sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
##rm -rf cilium-linux-amd64.tar.gz

docker pull kindest/node:v1.18.0
docker pull chuangtw/mcs
docker pull chuangtw/mchpa 
docker pull nginx
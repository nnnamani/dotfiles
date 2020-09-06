# install kubectl
sudo snap install kubectl --classic

# install helm
curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# install kvm
# sudo apt update
# sudo apt -y install apt-transport-https kvm-intel qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils

# install docker
sudo apt install -y docker-ce docker-ce-cli containerd.io

# install minikube
curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube
sudo mkdir -p /usr/local/bin/
sudo install minikube /usr/local/bin/

# how to execute minikube
# Create cluster
#
# $ minikube start --driver kvm2
#
# $ sudo minikube start --driver=none


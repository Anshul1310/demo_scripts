clear
sudo swapoff -a
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sudo sysctl --system
lsmod | grep br_netfilter
lsmod | grep overlay
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y containerd.io
containerd config default | sed -e 's/SystemdCgroup = false/SystemdCgroup = true/' -e 's/sandbox_image = "registry.k8s.io\/pause:3.6"/sandbox_image = "registry.k8s.io\/pause:3.9"/' | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl status containerd
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl
sudo kubeadm init
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
mkdir -p "$HOME"/.kube
sudo cp -i /etc/kubernetes/admin.conf "$HOME"/.kube/config
sudo chown "$(id -u)":"$(id -g)" "$HOME"/.kube/config
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.0/manifests/calico.yaml
kubeadm token create --print-join-command
kubeadm join 172.31.44.213:6443 --token ciwn97.l14s22zinwf9u1rh --discovery-token-ca-cert-hash sha256:7163cb86ffcd6d481e73262c2af2ea44b85f29df0e5f9ff69585581ac9750e63 --v=5
clear
kubectl get nodes
source ~./bashrc
source ./~bashrc
source ~/.bashrc
kubectl get nodes
clear
kubeadm token create --print-join-command
kubectl get nodes
source ~/.bashrc
kubectl get nodes
clear
kubectl get nodes
ls
ls -a
cd ..
ls
cd ubuntu
;s
ls
nano deployment.yaml
clear
ls
rm -rf deployment.yaml.save
ls
vim deployment.yaml
clear
ls
vim deployment.yaml
clear
l
ls
ls -a
vim deployment.yaml
rm -rf deployment.yaml
vim deployment.yaml
vim namespace.yaml
mkdir frontend
mkdir order
mkdir user
cp deployment.yaml /order/deployment.yaml
cp deployment.yaml order/deployment.yaml
cd order
ls
cd ..
cp deployemnt.yaml ./user/deployment.yaml
cp deployment.yaml /user/deployment.yaml
cp deployment.yaml ./user/deployment.yaml
cp deployment.yaml ./frontend/deployment.yaml
vim configmap.yaml
cd frontend
vim service.yaml;
vim service.yaml
clear
ls
cd frontend
ls
cd ..
cd order
ls
vim service.yaml
;s
ls
vim service.yaml
ls
cd ..
cd user
ls
vim service.yaml
cd ..
cd frontend
ls
vim service.yaml
vim deployment.yaml

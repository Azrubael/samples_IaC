# 2023-11-22    13:38
=====================
# https://minikube.sigs.k8s.io/docs/start/


* 222 - Minikube for K8s Setup
------------------------------
Ubuntu 20.04

    $ vagrant init
-------
    $ vim Vagrantfile
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  # config.vm.box = "geerlingguy/ubuntu2004"

  config.vm.network "private_network", ip: "192.168.56.12"
  # config.vm.synced_folder "../data", "/vagrant_data"
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |vb|
  #   # Customize the amount of memory on the VM:
     vb.memory = "4100"
     vb.cpus = 2
  end
  config.vm.provision "shell", path: "dockerup" 
end

-------

-------
    $ vim dockerup
#!/bin/bash

# Add Docker's official GPG key:
sudo apt-get update
sudo apt install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

# Add ubuntu user into docker group
sudo usermod -aG docker vagrant

-------

    $ vagrant up
...
    $ vagrant ssh
Welcome to Ubuntu 20.04.3 LTS (GNU/Linux 5.4.0-42-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
New release '22.04.3 LTS' available.
Run 'do-release-upgrade' to upgrade to it.

vagrant@vagrant:~$ sudo -i
root@vagrant:~# apt update

root@vagrant:~# docker images
REPOSITORY   TAG       IMAGE ID   CREATED   SIZE
root@vagrant:~# docker --version
Docker version 24.0.7, build afdd53b
root@vagrant:~# docker compose version
Docker Compose version v2.21.0
root@vagrant:~# exit
vagrant@vagrant:~$

# minikube install
Чтобы проверить, поддерживается ли виртуализация в Linux, выполните следующую команду и проверьте, что вывод не пустой:
    grep -E --color 'vmx|svm' /proc/cpuinfo
    

vagrant@vagrant:~$ curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 \
  && chmod +x minikube

vagrant@vagrant:~$ sudo mkdir -p /usr/local/bin/
vagrant@vagrant:~$ sudo install minikube /usr/local/bin/
vagrant@vagrant:~$ minikube version
minikube version: v1.32.0
commit: 8220a6eb95f0a4d75f7f2d7b14cef975f050512d

vagrant@vagrant:~$ minikube start
😄  minikube v1.32.0 on Ubuntu 20.04 (vbox/amd64)
...
🚜  Pulling base image ...
...
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default

vagrant@vagrant:~$ minikube kubectl get nodes
    > kubectl.sha256:  64 B / 64 B [-------------------------] 100.00% ? p/s 0s
    > kubectl:  47.56 MiB / 47.56 MiB [--------------] 100.00% 1.60 MiB p/s 30s
NAME       STATUS   ROLES           AGE    VERSION
minikube   Ready    control-plane   108s   v1.28.3

vagrant@vagrant:~$ alias k3s="minikube kubectl --"
vagrant@vagrant:~$ k3s get nodes
NAME       STATUS   ROLES           AGE     VERSION
minikube   Ready    control-plane   2m28s   v1.28.3

-------
vagrant@vagrant:~$ cat .kube/config
apiVersion: v1
clusters:
- cluster:
    certificate-authority: /home/vagrant/.minikube/ca.crt
    extensions:
    - extension:
        last-update: Wed, 22 Nov 2023 11:50:51 UTC
        provider: minikube.sigs.k8s.io
        version: v1.32.0
      name: cluster_info
    server: https://192.168.49.2:8443
  name: minikube
contexts:
- context:
    cluster: minikube
    extensions:
    - extension:
        last-update: Wed, 22 Nov 2023 11:50:51 UTC
        provider: minikube.sigs.k8s.io
        version: v1.32.0
      name: context_info
    namespace: default
    user: minikube
  name: minikube
current-context: minikube
kind: Config
preferences: {}
users:
- name: minikube
  user:
    client-certificate: /home/vagrant/.minikube/profiles/minikube/client.crt
    client-key: /home/vagrant/.minikube/profiles/minikube/client.key

-------
    
    
# Create a sample deployment and expose it on port 8080:
k3s create deployment hello-minikube --image=kicbase/echo-server:1.0
k3s expose deployment hello-minikube --type=NodePort --port=8080
k3s get services hello-minikube
minikube service hello-minikube


vagrant@vagrant:~$ minikube kubectl create deployment hello-minikube --vagrant@vagrant:~$ k3s create deployment hello-minikube --image=kicbase/echo-server:1.0
deployment.apps/hello-minikube created
vagrant@vagrant:~$ k3s expose deployment hello-minikube --type=NodePort --port=8080
service/hello-minikube exposed
vagrant@vagrant:~$ k3s get services hello-minikube
NAME             TYPE       CLUSTER-IP     EXTERNAL-IP   PORT(S)          AGE
hello-minikube   NodePort   10.96.28.255   <none>        8080:30538/TCP   9s
vagrant@vagrant:~$ minikube service hello-minikube
|-----------|----------------|-------------|---------------------------|
| NAMESPACE |      NAME      | TARGET PORT |            URL            |
|-----------|----------------|-------------|---------------------------|
| default   | hello-minikube |        8080 | http://192.168.49.2:30538 |
|-----------|----------------|-------------|---------------------------|
🎉  Opening service default/hello-minikube in default browser...
👉  http://192.168.49.2:30538

vagrant@vagrant:~$ k3s port-forward service/hello-minikube 7080:8080
Forwarding from 127.0.0.1:7080 -> 8080
Forwarding from [::1]:7080 -> 8080


minikube pause
minikube unpause
minikube stop
minikube delete --all

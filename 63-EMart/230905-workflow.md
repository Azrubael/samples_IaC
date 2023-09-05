# 2023-09-05    16:20
=====================


Microservice Project
--------------------

See EMart App architecture.
It was designed using microservice architecture:
    $ mkdir /mnt/SSDATA/CODE/DevOpsCompl20/230905-EMart/
    $ vim Vagrantfile
---------
Vagrant.configure("2") do |config|y
  config.vm.box = "ubuntu/focal64"

  # config.vm.network "private_network", ip: "192.168.33.10"
   config.vm.network "public_network"

  # Share an additional folder to the guest VM.
  # config.vm.synced_folder "../data", "/vagrant_data"
  # Disable the default share of the current code directory
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "3500"
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get install \
    ca-certificates \
    curl \
    gnupg \
    lsb-release -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
  SHELL
end
---------
    $ mv -f /mnt/SSDATA/CODE/DevOpsCompl20/230905-EMart/.vagrant/machines/default/virtualbox/private_key $HOME/.ssh/vagrant_EMart_private_key
    $ ln -sr $HOME/.ssh/vagrant_EMart_private_key /mnt/SSDATA/CODE/DevOpsCompl20/230905-EMart/.vagrant/machines/default/virtualbox/private_key
    $ vagrant up --provision
    $ vagrant ssh
Last login: Tue Sep  5 14:18:26 2023 from 10.0.2.2
vagrant@ubuntu-focal:~$ sudo -i
root@ubuntu-focal:~# docker version
Client: Docker Engine - Community
 Version:           24.0.5
 API version:       1.43
 Go version:        go1.20.6
...
root@ubuntu-focal:~# git clone https://github.com/devopshydclub/emartapp.git
Cloning into 'emartapp'...
...
root@ubuntu-focal:~# cd emartapp/
root@ubuntu-focal:~/emartapp# ls -l
total 40
-rw-r--r-- 1 root root  453 Sep  5 14:28 Dockerfile
-rw-r--r-- 1 root root 3723 Sep  5 14:28 Jenkinsfile
-rw-r--r-- 1 root root   11 Sep  5 14:28 README.md
drwxr-xr-x 4 root root 4096 Sep  5 14:28 client
-rw-r--r-- 1 root root  998 Sep  5 14:28 docker-compose.yaml
drwxr-xr-x 5 root root 4096 Sep  5 14:28 javaapi
drwxr-xr-x 4 root root 4096 Sep  5 14:28 kkartchart
drwxr-xr-x 3 root root 4096 Sep  5 14:28 nginx
drwxr-xr-x 7 root root 4096 Sep  5 14:28 nodeapi
-rw-r--r-- 1 root root   27 Sep  5 14:28 package-lock.json
root@ubuntu-focal:~/emartapp# vim docker-compose.yaml
---------
version: "3.8"

services:
  client:
    build:
      context: ./client
    ports:
      - "4200:4200"
    container_name: client
    depends_on:
      - api
      - webapi

  api:
    build:
      context: ./nodeapi
    ports:
      - "5000:5000"
    restart: always
    container_name: api
    depends_on:
      - nginx
      - emongo

  webapi:
    build:
      context: ./javaapi
    ports:
      - "9000:9000"
    restart: always
    container_name: webapi
    depends_on:
      - emartdb

  nginx:
    restart: always
    image: nginx:latest
    container_name: nginx
    volumes:
      - "./nginx/default.conf:/etc/nginx/conf.d/default.conf"
    ports:
      - "80:80"

  emongo:
    image: mongo:4
    container_name: emongo
    environment:
      - MONGO_INITDB_DATABASE=epoc
    ports:
      - "27017:27017"

  emartdb:
    image: mysql:8.0.33
    container_name: emartdb
    ports:
      - "3306:3306"
    environment:
      - MYSQL_ROOT_PASSWORD=emartdbpass
      - MYSQL_DATABASE=books
---------

    $ docker compose up -d
[+] Running 7/7
 ✔ Network emartapp_default  Created                              0.1s 
 ✔ Container emartdb         Started                              1.2s 
 ✔ Container nginx           Started                              1.0s 
 ✔ Container emongo          Started                              1.2s 
 ✔ Container webapi          Started                              2.6s 
 ✔ Container api             Started                              2.6s 
 ✔ Container client          Started                              3.4s
 
root@ubuntu-focal:~/emartapp# docker ps -as
CONTAINER ID   IMAGE             COMMAND                  CREATED              STATUS                                  PORTS                                               NAMES     SIZE
08888cca01bd   emartapp-client   "/docker-entrypoint.…"   About a minute ago   Exited (0) 23 seconds ago               80/tcp, 0.0.0.0:4200->4200/tcp, :::4200->4200/tcp   client    1.1kB (virtual 192MB)
b8c8011df6a6   emartapp-webapi   "java -jar book-work…"   About a minute ago   Up 12 seconds                           0.0.0.0:9000->9000/tcp, :::9000->9000/tcp           webapi    119kB (virtual 564MB)
4570a28d4229   emartapp-api      "docker-entrypoint.s…"   About a minute ago   Restarting (0) Less than a second ago                                                       api       55B (virtual 930MB)
1206928ce4ba   nginx:latest      "/docker-entrypoint.…"   About a minute ago   Restarting (1) 3 seconds ago                                                                nginx     0B (virtual 187MB)
61567bcebdd2   mysql:8.0.33      "docker-entrypoint.s…"   About a minute ago   Exited (2) About a minute ago                                                               emartdb   0B (virtual 565MB)
ea5f371bde20   mongo:4           "docker-entrypoint.s…"   About a minute ago   Exited (0) 23 seconds ago               0.0.0.0:27017->27017/tcp, :::27017->27017/tcp       emongo    0B (virtual 432MB)
root@ubuntu-focal:~/emartapp# ip addr show | grep 192.168.
    inet 192.168.1.101/24 brd 192.168.1.255 scope global dynamic enp0s8

# http://192.168.1.101/
# E-MART

root@ubuntu-focal:~/emartapp#  exit
logout
vagrant@ubuntu-focal:~$ exit
logout
    $ vagrant halt

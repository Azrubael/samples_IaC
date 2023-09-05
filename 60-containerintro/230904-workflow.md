# 2023-09-04    17:24
=====================

$ tree -alL 1
.
├── bin -> usr/bin
├── boot
├── cdrom
├── dev
├── etc
├── home
├── lib -> usr/lib
├── lib32 -> usr/lib32
├── lib64 -> usr/lib64
├── libx32 -> usr/libx32
├── lost+found
├── media
├── mnt
├── opt
├── proc
├── root
├── run
├── sbin -> usr/sbin
├── snap
├── srv
├── sys
├── tmp
├── usr
└── var

24 directories, 0 files

# https://docs.docker.com/get-started/overview/
# https://hub.docker.com/

Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications.
By taking advantage of Docker's methodologies for shipping, testing, and deploying code, you can significantly reduce the delay between writing code and running it in production.
Docker is an open platform for developing, shipping, and running applications. Docker enables you to separate your applications from your infrastructure so you can deliver software quickly. With Docker, you can manage your infrastructure in the same ways you manage your applications.
By taking advantage of Docker's methodologies for shipping, testing, and deploying code, you can significantly reduce the delay between writing code and running it in production.

Example: NGINX container needs only NGINX files.



* Hands on Docker Containers

    $ vim Vagrantfile
-------
Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/focal64"
  config.vm.network "public_network"
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
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
-------

    $ mkdir /mnt/SSDATA/CODE/DevOpsCompl20/230904-containerintro/
    $ cd /mnt/SSDATA/CODE/DevOpsCompl20/230904-containerintro/
    $ vagrant up
    $ mv -f /mnt/SSDATA/CODE/DevOpsCompl20/230904-containerintro/.vagrant/machines/default/virtualbox/private_key $HOME/.ssh/vagrant_230904_private_key
    $ vagrant up --provision
    $ vagrant ssh

vagrant@ubuntu-focal:~$ systemctl status docker
● docker.service - Docker Application Container Engine
     Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2023-09-04 15:29:29 UTC; 1min 10s ago
TriggeredBy: ● docker.socket
       Docs: https://docs.docker.com
   Main PID: 3042 (dockerd)
      Tasks: 9
     Memory: 28.0M
     CGroup: /system.slice/docker.service
             └─3042 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock

vagrant@ubuntu-focal:~$ sudo -i
root@ubuntu-focal:~# docker run hello-world
Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
719385e32844: Pull complete 
Digest: sha256:dcba6daec718f547568c562956fa47e1b03673dd010fe6ee58ca806767031d1c
Status: Downloaded newer image for hello-world:latest
    Hello from Docker!
    This message shows that your installation appears to be working correctly.
...

root@ubuntu-focal:~# docker images
REPOSITORY    TAG       IMAGE ID       CREATED        SIZE
hello-world   latest    9c7a54a9a43c   4 months ago   13.3kB
root@ubuntu-focal:~# docker ps -a
CONTAINER ID   IMAGE         COMMAND    CREATED         STATUS                     PORTS     NAMES
64e56875a92f   hello-world   "/hello"   3 minutes ago   Exited (0) 3 minutes ago             affectionate_wilbur

root@ubuntu-focal:~# docker run --name web01 -d -p 9080:80 nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
52d2b7f179e3: Pull complete 
fd9f026c6310: Pull complete 
055fa98b4363: Pull complete 
96576293dd29: Pull complete 
a7c4092be904: Pull complete 
e3b6889c8954: Pull complete 
da761d9a302b: Pull complete 
Digest: sha256:104c7c5c54f2685f0f46f3be607ce60da7085da3eaa5ad22d3d9f01594295e9c
Status: Downloaded newer image for nginx:latest
bc9f92bdfbb03103c8e8be81170556c5d9f2adc2b8ee9820da7b4627d90d59fe
root@ubuntu-focal:~# docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED         STATUS         PORTS                                   NAMES
bc9f92bdfbb0   nginx     "/docker-entrypoint.…"   4 seconds ago   Up 3 seconds   0.0.0.0:9080->80/tcp, :::9080->80/tcp   web01

root@ubuntu-focal:~# docker inspect web01
[
    {
        "Id": "bc9f92bdfbb03103c8e8be81170556c5d9f2adc2b8ee9820da7b4627d90d59fe",
        "Created": "2023-09-04T15:42:05.373452659Z",
        "Path": "/docker-entrypoint.sh",
        "Args": [
            "nginx",
            "-g",
            "daemon off;"
        ],
        "State": {
            "Status": "running",
            "Running": true,
            "Paused": false,
...
           "MacAddress": "02:42:ac:11:00:02",
            "Networks": {
                "bridge": {
...
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
...
                }
            }
        }
    }
]

root@ubuntu-focal:~# curl http://172.17.0.2:80
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>

root@ubuntu-focal:~# ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:72:ee:e2:ed:ce brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 86383sec preferred_lft 86383sec
    inet6 fe80::72:eeff:fee2:edce/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:48:e3:ca brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.101/24 brd 192.168.1.255 scope global dynamic enp0s8
       valid_lft 7185sec preferred_lft 7185sec
    inet6 fe80::a00:27ff:fe48:e3ca/64 scope link 
       valid_lft forever preferred_lft forever
4: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:bc:9b:cd:0e brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:bcff:fe9b:cd0e/64 scope link 
       valid_lft forever preferred_lft forever
6: veth1922c1b@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master docker0 state UP group default 
    link/ether fa:c6:38:a9:42:27 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::f8c6:38ff:fea9:4227/64 scope link 
       valid_lft forever preferred_lft forever

# http://192.168.1.101:9080/
# Welcome to nginx!

root@ubuntu-focal:~# mkdir images
root@ubuntu-focal:~# cd images/
root@ubuntu-focal:~/images# vim Dockerfile
---------
FROM ubuntu:18.04 AS BUILD_IMAGE
RUN apt-get update && apt-get install wget unzip -y
RUN wget https://www.tooplate.com/zip-templates/2128_tween_agency.zip
RUN unzip 2128_tween_agency.zip && cd 2128_tween_agency && tar -czf tween.tgz * && mv tween.tgz /root/tween.tgz

FROM ubuntu:18.04
LABEL "project"="Marketing"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install apache2 git wget -y
COPY --from=BUILD_IMAGE /root/tween.tgz /var/www/html/
RUN cd /var/www/html/ && tar xzf tween.tgz
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
VOLUME /var/log/apache2
WORKDIR /var/www/html/
EXPOSE 80
---------

root@ubuntu-focal:~/images# docker build -t tesimg .
root@ubuntu-focal:~/images# docker images                                                           
REPOSITORY   TAG       IMAGE ID       CREATED         SIZE                                          
tesimg       latest    06922820de0d   3 minutes ago   255MB                                         
nginx        latest    eea7b3dcba7e   2 weeks ago     187MB     

root@ubuntu-focal:~/images# docker run --name heureka -d -P tesimg
6f481f0087109e62f9930e74d2b8661c7616bdff9ea1315c7162248e91b36af2

root@ubuntu-focal:~/images# docker ps -as
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS          PORTS                                     NAMES     SIZE
6f481f008710   tesimg    "/usr/sbin/apache2ct…"   10 seconds ago   Up 9 seconds    0.0.0.0:32768->80/tcp, :::32768->80/tcp   heureka   3B (virtual 255MB)
bc9f92bdfbb0   nginx     "/docker-entrypoint.…"   48 minutes ago   Up 20 minutes   0.0.0.0:9080->80/tcp, :::9080->80/tcp     web01     1.09kB (virtual 187MB)

# http://192.168.1.101:32768/
# We are ready to serve for your digital marketing
    AND
# http://192.168.1.101:9080/
# Welcome to nginx!

root@ubuntu-focal:~/images# docker rm web01 heureka -f
web01
heureka
root@ubuntu-focal:~/images# docker images
REPOSITORY   TAG       IMAGE ID       CREATED          SIZE
tesimg       latest    06922820de0d   10 minutes ago   255MB
nginx        latest    eea7b3dcba7e   2 weeks ago      187MB
root@ubuntu-focal:~/images# docker rmi 06922820de0d eea7b3dcba7e -f
Untagged: tesimg:latest
Deleted: sha256:06922820de0d32e7932c907d94a280e8598556c0fdbd6984a956397f92d3e462
Untagged: nginx:latest
Untagged: nginx@sha256:104c7c5c54f2685f0f46f3be607ce60da7085da3eaa5ad22d3d9f01594295e9c
Deleted: sha256:eea7b3dcba7ee47c0d16a60cc85d2b977d166be3960541991f3e6294d795ed24
Deleted: sha256:589bcc284f24d6548cd3cef06ace5f6ebc4f23a48a5763f2f9d3d30b0f9dadf5
Deleted: sha256:b3addc7069fafd183d88d1a40bb3dfe51227d45e4fe8e59b81a2fda7614ebbc1
Deleted: sha256:5bf28af6a2188fa2d657e451213761b03e115e4c24ee72c41da34a241fe81ca1
Deleted: sha256:2496134da21702d935bee1334ae42baf26d0197af91275e5c1a11eee31299121
Deleted: sha256:c7e60968a54882c23483c3acb0ff1f415ce0f98184dfbed3fb9080447d79b313
Deleted: sha256:49bfd4a4ea578aefcacdfd87efdc4999d6a4e4b7f00322484cac67ff7671389e
Deleted: sha256:511780f88f80081112aea1bfdca6c800e1983e401b338e20b2c6e97f384e4299
root@ubuntu-focal:~/images# docker builder prune --all
WARNING! This will remove all build cache. Are you sure you want to continue? [y/N] y
ID						RECLAIMABLE	SIZE		LAST ACCESSED
3yilo5snwf55ppv8dpv7w7ogs               	true 		0B        	19 minutes ago
28mp4kebho3l4agtnin7y65rk*              	true 	6.384MB   	10 minutes ago
wptzxk0oxboci4zf6huus1y4t*              	true 	0B        	10 minutes ago
q2hn8o00fpwvw87wdix24spbm               	true 	0B        	10 minutes ago
rvmr1sg9tg0pwa83vollu5v97*              	true 	612B      	10 minutes ago
idqwp7ueuv4udfc1r2if9utnp               	true 	2.905MB   	10 minutes ago
lknl00eruqkv5rsktsz5tpvr2               	true 	3.478MB   	10 minutes ago
o6lwk8d7r9u3a6eqmyt4l95cy               	true 	53.39MB   	10 minutes ago
ho5z86pv7c3rpfwtgo4mizhm8               	true 	2.906MB   	10 minutes ago
z2gx675j0x0rspc4k75031acw               	true 	186MB     	10 minutes ago
gubxl8tadwbtiure9kczz7zlv               	true 	0B        	10 minutes ago
Total:	255MB

root@ubuntu-focal:~/images# exit
logout
vagrant@ubuntu-focal:~$ exit
logout

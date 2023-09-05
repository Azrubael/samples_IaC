# 2023-09-05    11:28
=====================


Vprofile Project on Containers
------------------------------
    $ vagrant ssh
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-156-generic x86_64)
...
Last login: Mon Sep  4 16:10:13 2023 from 10.0.2.2
vagrant@ubuntu-focal:~$ sudo -i
root@ubuntu-focal:~# mkdir compose
root@ubuntu-focal:~# cd compose/
root@ubuntu-focal:~/compose# docker compose
    Usage:  docker compose [OPTIONS] COMMAND
    Define and run multi-container applications with Docker.
...
root@ubuntu-focal:~/compose# wget https://raw.githubusercontent.com/devopshydclub/vprofile-project/vp-docker/compose/docker-compose.yml
root@ubuntu-focal:~/compose# vim docker-compose-v3_8.yml
-------
version: '3.8'
services:
  vprodb:
    image: vprocontainers/vprofiledb
    ports:
      - "3306:3306"
    volumes:
      - vprodbdata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=vprodbpass
  vprocache01:
    image: memcached
    ports:
      - "11211:11211"
  vpromq01:
    image: rabbitmq
    ports:
      - "15672:15672"
    environment:
      - RABBITMQ_DEFAULT_USER=guest
      - RABBITMQ_DEFAULT_PASS=guest
  vproapp:
    image: vprocontainers/vprofileapp
    ports:
      - "8080:8080"
    volumes:
      - vproappdata:/usr/local/tomcat/webapps
  vproweb:
    image: vprocontainers/vprofileweb
    ports:
      - "80:80"
volumes:
  vprodbdata: {}
  vproappdata: {}
------

root@ubuntu-focal:~/compose# vim docker-compose.yml
------
version: '3'
services:
  vpronginx:
    image: visualpath/vpronginx
    ports:
      - "80:80"
  vproapp:
    image: imranvisualpath/vproappfix
    ports:
      - "8080:8080"
  vprocache01:
    image: memcached
    ports:
      - "11211:11211"
  vpromq01:
    image: rabbitmq
    ports:
      - "15672:15672"
    environment:
      - RABBITMQ_DEFAULT_USER=guest
      - RABBITMQ_DEFAULT_PASS=guest
  vprodb:
    image: imranvisualpath/vprdbfix
    ports:
      - "3306:3306"
    volumes:
      - vprodbdata:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=vprodbpass
volumes:
  vprodbdata: {}
  vproappdata: {}
------

root@ubuntu-focal:~/compose# docker compose up -d
root@ubuntu-focal:~/compose# docker compose up -d
[+] Running 5/0
 ✔ Container compose-vpronginx-1    Running                          0.0s 
 ✔ Container compose-vproapp-1      Running                          0.0s 
 ✔ Container compose-vprocache01-1  Running                          0.0s 
 ✔ Container compose-vpromq01-1     Running                          0.0s 
 ✔ Container compose-vprodb-1       Running                          0.0s
 
root@ubuntu-focal:~/compose# docker ps -as
CONTAINER ID   IMAGE                        COMMAND                  CREATED         STATUS         PORTS                                                                                                NAMES                   SIZE
13e4a82f87ef   rabbitmq                     "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   4369/tcp, 5671-5672/tcp, 15691-15692/tcp, 25672/tcp, 0.0.0.0:15672->15672/tcp, :::15672->15672/tcp   compose-vpromq01-1      0B (virtual 226MB)
7803535a5129   imranvisualpath/vprdbfix     "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp                                                 compose-vprodb-1        6B (virtual 565MB)
44f83afbe859   memcached                    "docker-entrypoint.s…"   2 minutes ago   Up 2 minutes   0.0.0.0:11211->11211/tcp, :::11211->11211/tcp                                                        compose-vprocache01-1   0B (virtual 107MB)
216af750c259   imranvisualpath/vproappfix   "catalina.sh run"        2 minutes ago   Up 2 minutes   0.0.0.0:8080->8080/tcp, :::8080->8080/tcp                                                            compose-vproapp-1       56.9MB (virtual 381MB)
de77cdb1e0f6   visualpath/vpronginx         "nginx -g 'daemon of…"   2 minutes ago   Up 2 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp                                                                    compose-vpronginx-1     2B (virtual 108MB)

root@ubuntu-focal:~/compose# ip addr show
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 02:72:ee:e2:ed:ce brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
       valid_lft 84650sec preferred_lft 84650sec
    inet6 fe80::72:eeff:fee2:edce/64 scope link 
       valid_lft forever preferred_lft forever
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
    link/ether 08:00:27:48:e3:ca brd ff:ff:ff:ff:ff:ff
>>> inet 192.168.1.101/24 brd 192.168.1.255 scope global dynamic enp0s8
       valid_lft 5452sec preferred_lft 5452sec
    inet6 fe80::a00:27ff:fe48:e3ca/64 scope link 
       valid_lft forever preferred_lft forever
4: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:f3:9a:2f:1c brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
5: br-5c20cbeee4a5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:40:dc:b4:88 brd ff:ff:ff:ff:ff:ff
    inet 172.18.0.1/16 brd 172.18.255.255 scope global br-5c20cbeee4a5
       valid_lft forever preferred_lft forever
    inet6 fe80::42:40ff:fedc:b488/64 scope link 
       valid_lft forever preferred_lft forever
7: veth61ddd17@if6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-5c20cbeee4a5 state UP group default 
    link/ether 5a:fd:53:16:6e:50 brd ff:ff:ff:ff:ff:ff link-netnsid 3
    inet6 fe80::58fd:53ff:fe16:6e50/64 scope link 
       valid_lft forever preferred_lft forever
9: veth64a98d3@if8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-5c20cbeee4a5 state UP group default 
    link/ether 36:1c:15:f4:e8:39 brd ff:ff:ff:ff:ff:ff link-netnsid 2
    inet6 fe80::341c:15ff:fef4:e839/64 scope link 
       valid_lft forever preferred_lft forever
11: veth6a294f1@if10: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-5c20cbeee4a5 state UP group default 
    link/ether 9a:c4:ec:38:cb:22 brd ff:ff:ff:ff:ff:ff link-netnsid 1
    inet6 fe80::98c4:ecff:fe38:cb22/64 scope link 
       valid_lft forever preferred_lft forever
13: vethe6563c1@if12: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-5c20cbeee4a5 state UP group default 
    link/ether 3e:82:d1:3f:ec:6e brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::3c82:d1ff:fe3f:ec6e/64 scope link 
       valid_lft forever preferred_lft forever
15: vethe6b2463@if14: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-5c20cbeee4a5 state UP group default 
    link/ether 36:63:03:30:d7:1c brd ff:ff:ff:ff:ff:ff link-netnsid 4
    inet6 fe80::3463:3ff:fe30:d71c/64 scope link 
       valid_lft forever preferred_lft forever


# http://192.168.1.101/login
# VISUAL VProfile   PATH
# TECHNOLOGIES
# ABOUT
# BLOG                LOGIN                 SIGN UP
                      admin_vp/admin_vp

root@ubuntu-focal:~/compose# ip addr show | grep 192.168
    inet 192.168.1.101/24 brd 192.168.1.255 scope global dynamic enp0s8


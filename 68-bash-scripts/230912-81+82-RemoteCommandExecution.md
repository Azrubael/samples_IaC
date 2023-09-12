# 2023-09-11    14:28
=====================
# Remote Command Execution
--------------------------

How we can execute command from `scriptbox` instance to `web01` and `web02`. And later we'll aso add one more machine `web03` which will be Ubuntu machine?

    $ vagrant up web01
Bringing machine 'web01' up with 'virtualbox' provider...
...
/mnt/SSDATA/CODE/DevOpsCompl20/230906-bash-scrits/.vagrant/machines/web01/virtualbox/private_key

    $ mv -f /mnt/.../.vagrant/machines/web01/virtualbox/private_key $HOME/.ssh/vagrant_web01_private_key
    $ ln -sr $HOME/.ssh/vagrant_web01_private_key /mnt/.../.vagrant/machines/web01/virtualbox/private_key

    $ mv -f /mnt/.../.vagrant/machines/web02/virtualbox/private_key $HOME/.ssh/vagrant_web02_private_key
    $ ln -sr $HOME/.ssh/vagrant_web02_private_key /mnt/.../.vagrant/machines/web02/virtualbox/private_key

    $ mv -f /mnt/.../.vagrant/machines/web03/virtualbox/private_key $HOME/.ssh/vagrant_web03_private_key
    $ ln -sr $HOME/.ssh/vagrant_web03_private_key /mnt/.../.vagrant/machines/web03/virtualbox/private_key

###### АЛЬТЕРНАТИВА ######
    $ vim up_script.sh
#!/bin/bash
INSTANCES="scriptbox web01 web02 web03"
for vm in $INSTANCES; do
  vagrant up $vm &>> $PWD/vagrant_up.log
  current_key_path="$PWD/.vagrant/machines/$vm/virtualbox/private_key"
  ssh_key_path="$HOME/vagrant_$vm"+"_private_key"
  mv -f $current_key_path $ssh_key_path &>> $PWD/vagrant_up.log
  ln -sr $ssh_key_path $current_key_path &>> $PWD/vagrant_up.log
  vagrant $vm reload --provision &>> $PWD/vagrant_up.log
done
-------


    $ vagrant ssh web01
[vagrant@localhost ~]$ sudo -i
[root@localhost ~]# vi /etc/hostname
web01
[root@localhost ~]# hostname web01
[root@localhost ~]# exit
logout
[vagrant@localhost ~]$ exit
logout
    $ vagrant ssh web01
Last login: Mon Sep 11 13:38:12 2023 from 10.0.2.2
[vagrant@web01 ~]$ sudo -i
[root@web01 ~]#     <--- новое имя хоста

# далее повторяем аналогичную процедуру для остальных инстансов
    $ vagrant ssh scriptbox
Last login: Mon Sep 11 12:27:20 2023 from 10.0.2.2
[vagrant@scriptbox ~]$ sudo -i
-------
[root@scriptbox ~]# vi /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

192.168.56.13 web01
192.168.56.14 web02
192.168.56.15 web03
-------

[root@scriptbox ~]# ping web01
PING web01 (192.168.56.13) 56(84) bytes of data.
64 bytes from web01 (192.168.56.13): icmp_seq=1 ttl=64 time=2.95 ms
64 bytes from web01 (192.168.56.13): icmp_seq=2 ttl=64 time=1.11 ms
^C
--- web01 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1002ms
rtt min/avg/max/mdev = 1.116/2.033/2.951/0.918 ms
[root@scriptbox ~]# ping web02
PING web02 (192.168.56.14) 56(84) bytes of data.
64 bytes from web02 (192.168.56.14): icmp_seq=1 ttl=64 time=2.43 ms
64 bytes from web02 (192.168.56.14): icmp_seq=2 ttl=64 time=1.24 ms
64 bytes from web02 (192.168.56.14): icmp_seq=3 ttl=64 time=0.887 ms
^C
--- web02 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2004ms
rtt min/avg/max/mdev = 0.887/1.521/2.433/0.662 ms
[root@scriptbox ~]# ping web03
PING web03 (192.168.56.15) 56(84) bytes of data.
64 bytes from web03 (192.168.56.15): icmp_seq=1 ttl=64 time=1.01 ms
64 bytes from web03 (192.168.56.15): icmp_seq=2 ttl=64 time=1.07 ms
64 bytes from web03 (192.168.56.15): icmp_seq=3 ttl=64 time=1.14 ms
^C
--- web03 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2001ms
rtt min/avg/max/mdev = 1.018/1.078/1.147/0.065 ms

# вход в инстанс `web01`из shell `scriptbox`

[root@scriptbox ~]# ssh vagrant@web01
The authenticity of host 'web01 (192.168.56.13)' can't be established.
ECDSA key fingerprint is SHA256:mc0p/z9/+4s4SjrnLCx/tV2t8ziWNB049IHGz1V0a8U.
ECDSA key fingerprint is MD5:06:81:b2:a2:92:4e:a4:cf:a8:57:8a:5b:90:cd:00:d5.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'web01,192.168.56.13' (ECDSA) to the list of known hosts.
vagrant@web01's password: 
Last login: Mon Sep 11 13:41:46 2023 from 10.0.2.2
[vagrant@web01 ~]$ hostname
web01
[vagrant@web01 ~]$ logout
Connection to web01 closed.
[root@scriptbox ~]#

# возврат в shell `scriptbox`

[root@scriptbox ~]# ssh vagrant@web01
vagrant@web01's password: 
Last login: Mon Sep 11 13:59:34 2023 from 192.168.56.12
[vagrant@web01 ~]$ sudo -i
[root@web01 ~]# useradd devops
[root@web01 ~]# passwd      <--- установка пароля новому пользователю
Changing password for user root.
New password: 
BAD PASSWORD: The password is shorter than 8 characters
Retype new password: 
passwd: all authentication tokens updated successfully.

------
[root@web01 ~]# visudo      <--- добавление `devops` в `sudo`
...
## Allow root to run any commands anywhere
root    ALL=(ALL)       ALL
devops  ALL=(ALL)       NOPASSWD: ALL
...
------

[root@web01 ~]# exit    <--- возврат из `web01` в shell `scriptbox`
logout
[vagrant@web01 ~]$ exit
logout
Connection to web01 closed.

# повторяем то же самое для web02 и web03 (добавляем devops пользователя,
# а затем вносим его в группу sudo)

...

# но для Ubuntu вход производится не по паролю, а по ключу

[root@scriptbox ~]# ssh vagrant@web03
The authenticity of host 'web03 (192.168.56.15)' can't be established.
ECDSA key fingerprint is SHA256:xZmmiyZZk3HYDKK8Q2L3aq+9jQzkMOmWxLB6n0ptO9U.
ECDSA key fingerprint is MD5:d6:e3:b4:d3:7f:3f:f5:03:a1:bc:80:b2:96:8c:e3:f0.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 'web03,192.168.56.15' (ECDSA) to the list of known hosts.
Permission denied (publickey).
[root@scriptbox ~]# ssh vagrant@ubuntu-web03
ssh: Could not resolve hostname ubuntu-web03: Name or service not known
[root@scriptbox ~]# exit
logout
[vagrant@scriptbox ~]$ exit
logout
    $ vagrant ssh web03
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-156-generic x86_64)
...
Last login: Mon Sep 11 13:53:29 2023 from 10.0.2.2
vagrant@ubuntu-web03:~$ sudo -i

-------
root@ubuntu-web03:~# vim /etc/ssh/sshd_config
...
# To disable tunneled clear text passwords, change to no here!
PasswordAuthentication no
...
-------

root@ubuntu-web03:~# vim /etc/ssh/sshd_config
root@ubuntu-web03:~# systemctl restart ssh
root@ubuntu-web03:~# logout
vagrant@ubuntu-web03:~$ logout
    $ vagrant ssh scriptbox
Last login: Mon Sep 11 13:55:23 2023 from 10.0.2.2
vagrant@ubuntu-web03:~$ sudo -i
root@ubuntu-web03:~# adduser devops
...
Is the information correct? [Y/n] Y
root@ubuntu-web03:~# export EDITOR=vim  <--- set vim as default

-------
root@ubuntu-web03:~# visudo
...
# User privilege specification
root    ALL=(ALL:ALL) ALL
devops  ALL=(ALL:ALL) NOPASSWD: ALL
...
-------

root@ubuntu-web03:~# logout
vagrant@ubuntu-web03:~$ logout
Connection to web03 closed.     <--- again return to `scriptbox`

[root@scriptbox ~]# ssh devops@web01 uptime
devops@web01's password: 
 14:32:55 up  1:15,  0 users,  load average: 0.00, 0.01, 0.05
# была запущена команда на `web01` из `scriptbox` от имени `devops`

[root@scriptbox ~]# ssh devops@web02 uptime
devops@web02's password: 
 14:34:27 up  1:14,  0 users,  load average: 0.06, 0.04, 0.05
# была запущена команда на `web02` из `scriptbox` от имени `devops`

[root@scriptbox ~]# ssh devops@web03 uptime
devops@web03's password: 
 14:34:59 up  1:13,  0 users,  load average: 0.00, 0.00, 0.00
# была запущена команда на `web03` из `scriptbox` от имени `devops`




# SSH Key Exchange.mp4
----------------------
Альтернативой входу по паролю является вход с применением ключа.
Вход с применением ключа рассматривается, как более безопасный.
Для применения ключа его необходимо сгенерировать командой `ssh-keygen`
    $ vagrant reload
    $ vagrant ssh scriptbox
Last login: Mon Sep 11 14:21:08 2023 from 10.0.2.2
[vagrant@scriptbox ~]$ sudo -i
[root@scriptbox ~]# ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/root/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /root/.ssh/id_rsa.    <--- lock tool
Your public key has been saved in /root/.ssh/id_rsa.pub.    <--- key tool
The key fingerprint is:
SHA256:OOQM75bHqnTHRoBxJPqvwYUGDGnM0wGQl5MAm/YA1pU root@scriptbox
...

[root@scriptbox ~]# ssh-copy-id devops@web01                <--- copy public key
...
    Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'devops@web01'"
and check to make sure that only the key(s) you wanted were added.
[root@scriptbox ~]# ssh-copy-id devops@web02
...
    Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'devops@web02'"
and check to make sure that only the key(s) you wanted were added.
[root@scriptbox ~]# ssh-copy-id devops@web03
... 
    Number of key(s) added: 1
Now try logging into the machine, with:   "ssh 'devops@web03'"
and check to make sure that only the key(s) you wanted were added.

[root@scriptbox ~]#     <--- теперь выполним какую-то команду без пароля
[root@scriptbox ~]# ssh devops@web01 uptime
 10:53:42 up 8 min,  0 users,  load average: 0.00, 0.02, 0.04
[root@scriptbox ~]# ssh devops@web02 uptime
 10:53:48 up 8 min,  0 users,  load average: 0.00, 0.04, 0.05
[root@scriptbox ~]# ssh devops@web03 uptime
 10:53:51 up 8 min,  0 users,  load average: 0.00, 0.12, 0.10
 
 
# полная команда с указанием специфического публичного ключа
[root@scriptbox ~]# ssh -i ~/.ssh/id_rsa devops@web01 uptime
 10:59:17 up 14 min,  0 users,  load average: 0.00, 0.01, 0.04

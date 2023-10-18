# 2023-10-17    15:58
=====================


* 178 - Setup Ansible & Infra
-----------------------------
# Ansible installation
https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-and-upgrading-ansible

# Ansible installation on Ubuntu
https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu


# https://aws.amazon.com
# Ubuntu Server 18.04 LTS
Ubuntu 18.04 Server Packaged by IOanyT Innovations
IOanyT Innovations, Inc.
# Control Machine - 1 pcs
> AWS > EC2 > Launch instance > t2.micro > { 'Instances': 1 }
    { 'Name': 'Control Machine'; 'OS': 'ubuntu-18'; 'Flavour': 'bionic' } >
    Ubuntu 18.04 Server Packaged by IOanyT Innovations >
    Sequrity group = Ansible-SG > Key = 230724-ec2-t2micro >
    sh: {
#!/bin/bash
sudo apt update
sudo apt install software-properties-common --yes
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible --yes
    }    > *Launch instance*
    
    
CentOS 7 (x86_64) - with Updates HVM
Amazon Web Services 
CentOS-7-2111-20220825_1.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42
ami-002070d43b0a4f171
# Vprofile Web Servers - 2pcs
> AWS > EC2 > Launch instance > t2.micro > { 'Instances': 2 } >
    { 'Name': 'vprofile-web'; 'OS': 'Centos7' } >
    CentOS-7 ... ami-002070d43b0a4f171>
    Sequrity group = vprofile-web-SG > Key = 230724-ec2-t2micro >
    sh: { # Don't need }    > *Launch instance*

    
CentOS 7 (x86_64) - with Updates HVM
Amazon Web Services 
CentOS-7-2111-20220825_1.x86_64-d9a3032a-921c-4c6d-b150-bde168105e42
ami-002070d43b0a4f171
# Vprofile Data Base - 1pcs
> AWS > EC2 > Launch instance > t2.micro > { 'Instances': 1 } >
    { 'Name': 'vprofile-db'; 'OS': 'Centos7' } >
    CentOS-7 ... ami-002070d43b0a4f171>
    Sequrity group = vprofile-db-SG > Key = 230724-ec2-t2micro >
    sh: { # Don't need }    > *Launch instance*  
    
    

[timecode 07:29]
    $ ssh -i "~/.aws/230724-ec2-t2micro.pem" ubuntu@54.209.23.188
...
Last login: Fri Jul  1 06:58:30 2022 from 180.151.238.62
ubuntu@ip-172-31-31-168:~$ hostnamectl status
   Static hostname: ip-172-31-31-168
         Icon name: computer-vm
           Chassis: vm
        Machine ID: 92a505e7452a4d4d9316f208d64ea7a0
           Boot ID: dd1baa4bbb754a0e9ea73f0923e41811
    Virtualization: xen
  Operating System: Ubuntu 18.04.6 LTS
            Kernel: Linux 5.4.0-1103-aws
      Architecture: x86-64
ubuntu@ip-172-31-31-168:~$ sudo -i
root@ip-172-31-31-168:~# ansible --version
ansible 2.9.27
  config file = /etc/ansible/ansible.cfg
  configured module search path = [u'/root/.ansible/plugins/modules', u'/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python2.7/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 2.7.17 (default, Mar  8 2023, 18:40:28) [GCC 7.5.0]
root@ip-172-31-31-168:~# exit
logout
ubuntu@ip-172-31-31-168:~$ mkdir vprofile
ubuntu@ip-172-31-31-168:~$ cd vprofile
ubuntu@ip-172-31-31-168:~/vprofile$ mkdir exercise1




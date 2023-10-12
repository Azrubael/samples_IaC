# 2023-10-11    17:45
=====================

* 157 - Jenkins Master and Slave
--------------------------------
So fat whatever we are running on Jenkins, we are running it frm Jenkins Master. But there will be situations or scenarion or use cases where you need to run jobs from some other machine.
Those other machines will be the slave machines for Jenkins. And there are some very common use cases for that:
+ Load Distribution (or distributed builds)
    Jenkins Master will pick up a slave from its arsenal and execute the job on a selected slave.
+ Cross platform builds
    Executing Build of other platforms like .Net (msBuild for Windows), IOS (MacOS) from Jenkins Master (Linux).
+ Software testing (ecpesially if you have Continuous Delivery)
    Execute tests automation scripts from node. And for this you really need to work very closely with the software testers.
    
There are a lot of other usecases where you will want to run your scripts (Shell, Python, Ansible playbook etc.). So you can add some machine as a slave and run for that matter anything that you want to run (commands or scripts).

   +-------------- Jenkins master-----------------+
   |                |          |                  |
Wondows          Ubuntu       RHEL         Testing Computer

This gives immense power to Jenkins, if you add any computer in network as Jenkins Node and execute commands on Nodes (commands scripts etc.).
So you can use Jenkins as a cetralized platform o execute anything in your infrastructure.

*Prerequisites for Node setup* (the Slave setup)
1. You can have any OS
2. You have to have access to Node from Master computer
    Note: check firewall rules (or sequrity groups or any other kind third party firewall)
3. You need to have Java, JRE or JDK based on your quirement
4. You need a user in the slave node that master Jenkins will use to connect. 
5. A directory with the user's ownership. So Jenkins will use this user to connect to your slave node machine and will create files or access files in the directory.
6. Tools as requied by the Jenkins job (Mave, Ant, Git etc.)
    You can manage this from global tool configuration also or you can log in into the slave and install the right tools like you need.

Now let's see how it works.
I will use as a slave previously created Ubuntu 20.04 vagrant machine `svm` because we alteade have java on it.

    $ cd /mnt/SSDATA/CODE/DevOpsCompl20/samples_IaC/148-jenkins-docker-ci/
    $ vagrant up jvm svm
    $ vagrant ssh svm
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-162-generic x86_64)
Last login: Mon Oct  9 10:33:51 2023 from 10.0.2.2
vagrant@svm01:~$ sudo -i
root@svm01:~# useradd devops
root@svm01:~# passwd devops
New password: 
Retype new password: 
passwd: password updated successfully
# удаление пользователя, созданного без домашней директории, для Убунду нужна другая команда
root@svm01:~# userdel -r devops
userdel: devops mail spool (/var/mail/devops) not found
userdel: devops home directory (/home/devops) not found

root@svm01:~# adduser devops
Adding user `devops' ...
Adding new group `devops' (1002) ...
Adding new user `devops' (1002) with group `devops' ...
Creating home directory `/home/devops' ...
Copying files from `/etc/skel' ...
New password: 
Retype new password: 
passwd: password updated successfully
...
root@svm01:~# mkdir /opt/jenkins-slave
root@svm01:~# chown devops.devops /opt/jenkins-slave -R

# now we'll enable password login which disabled by default
root@svm01:~# vim /etc/ssh/sshd_config
...
PasswordAuthentication yes
...
    
root@svm01:~# systemctl restart ssh
# on Linux RHEL instead ssh it will be 'sshd`

[timecode 08:30]
# Now we go to Jenkins server
# http://192.168.56.11:8080/
> Jenkins > Dashboard > Manage Jenkins > Nodes > New Node >
    { 'name': 'svm-node' } > Number of executors = 1 [any] >
    Remote root direstory = /opt/jenkins-slave >
    Labels = SVMnode >  Launch method = Launch agents via SSH  >
    Host = 192.168.56.19 > Credentials > Add - Jenkins >
    Kind = Username with password
    Username = devops
    Password = xxx
    ID = svm-devops-login
    Non verifying Verification Strategy > Save > svm-node > Log >
    ...
    [10/11/23 16:04:13] [SSH] Authentication successful.
    ...
    > Status

# Now our slave is up and running and we can use it.
[timeckde 13:50]    

We'll create a simple job to test it.
> Jenkins > Dashboard > New item > { 'name': 'test-slave' } >
    Freestyle project > OK > Configure > Build steps > Execute shell >
    Command: {pwd && whoami && ls -ltr} > Save > BUILD NOW

*Console output:*
        Started by user vagrant
        Running as SYSTEM
        Building remotely on svm-node (SVMnode) in workspace /opt/jenkins-slave/workspace/test-slave
        [test-slave] $ /bin/sh -xe /tmp/jenkins15664131120069075296.sh
        + pwd
        /opt/jenkins-slave/workspace/test-slave
        + whoami
        devops
        + ls -ltr
        total 0
        Finished: SUCCESS

# ради интереса проверим содержимое папочек внутри ноды
    $ vagrant ssh svm
...
Last login: Wed Oct 11 15:29:08 2023 from 10.0.2.2
vagrant@svm01:~$ sudo -i
root@svm01:/opt# cd jenkins-slave
root@svm01:/opt/jenkins-slave# ls
remoting/  remoting.jar  workspace/
root@svm01:/opt/jenkins-slave# ls workspace/
test-slave

# Внутри настроек job Configuraion есть интересная опция
*Restrict where this project can be run*
    By default, builds of this project may be executed on any agents that are available and configured to accept new builds. But when this option is checked, you have the possibility to ensure that builds of this project only occur on a certain agent, or set of agents.
    Label Expression = svm-node
# There is a warranty that this job will run only on this node!

So if you want to disable of automatic selection of this node, you can select an option:
> Jenkins > Dashboard > Nodes > svm-node > Configure >
    Usage = Only build jobs with label expressions matching this node >
    SAVE
# Now Jenkins will not select this node automatically, only if you give
# it obviously in a particular job.
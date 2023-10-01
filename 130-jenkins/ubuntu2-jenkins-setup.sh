#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install openjdk-17-jdk -y
sudo apt-get install maven -y

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

# Эти команды для Vagrant_2.3.7 & VirtualBOX_6.1 пришлось запускать вручную
sudo apt-get update
sudo apt-get install jenkins -y
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java
sudo systemctl status jenkins
echo " " >> ~/.bashrc
echo "alias mvn17=/usr/lib/jvm/java-17-openjdk-amd64/bin/java" >> ~/.bashrc
echo "alias mvn8=/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java" >> ~/.bashrc

# Для входа в jenkins используется браузер локального ПК
# http://192.168.56.7:8080/
# Chose *Select Pluging to install*
# *Build tools* > Ant:Off > Nodejs:On > INSTALL
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

# Эти команды пришолсь запускать вручную
sudo apt-get update
sudo apt-get install jenkins -y
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java
sudo systemctl status jenkins

# Для входа в jenkins используется браузер локального ПК
# http://192.168.56.7:8080/
# Chose *Select Pluging to install*
# *Build tools* > Ant:Off > Nodejs:On > INSTALL
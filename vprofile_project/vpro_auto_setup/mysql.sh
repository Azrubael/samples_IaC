#!/bin/bash
DATABASE_PASS='admin123'
sudo yum update -y
sudo yum install -y epel-release -y
sudo yum install git -y
sudo yum install unzip -y
sudo yum install mc -y
sudo yum install mariadb-server -y

sudo echo "## vagrant-hostmanager-start
192.168.56.11	web01
192.168.56.12	app01
192.168.56.14	mc01
192.168.56.15	db01
192.168.56.16	rmq01
## vagrant-hostmanager-end" >> /etc/hosts

# starting & enabling mariadb-server
sudo systemctl start mariadb
sudo systemctl enable mariadb
cd /tmp/
git clone -b main https://github.com/hkhcoder/vprofile-project.git
#restore the dump file for the application
sudo mysqladmin -u root password "$DATABASE_PASS"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
sudo mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
sudo mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
sudo mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
sudo mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Restart mariadb-server
sudo systemctl restart mariadb


#starting the firewall and allowing the mariadb to access from port no. 3306
# sudo systemctl start firewalld
# sudo systemctl enable firewalld
# sudo firewall-cmd --get-active-zones
# sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent
# sudo firewall-cmd --reload
# sudo systemctl restart mariadb

# 2023-12-04    16:29
=====================


* 137 - Jenkins & Sonarqube Setup
---------------------------------


git clone -b ci-jenkins https://github.com/devopshydclub/vprofile-project

# Launch Jenkins Server
> AWS > EC2 > Launch Instance > Name = JenkinsServer > Ubuntu20.04 >
    t2.small > sshkey=230724-ec2-t2micro > SG=kops-k8s-SG > 10Gib >
-------
#!/bin/bash

sudo apt-get update
sudo apt install openjdk-11-jdk -y --fix-missing
sudo apt-get update
sudo apt-get install maven -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
/usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
/etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update
sudo apt-get install jenkins -y
-------
    *LAUNCH INSTANCE*


# Check Jenkins Server
* 138 - Server UI Logins
------------------------
[timecode 00:00]
    $ ssh -i "~/.aws/230724-ec2-t2micro.pem" ubuntu@44.202.137.122
ubuntu@ip-172-31-93-138:~$ systemctl status jenkins
● jenkins.service - Jenkins Continuous Integration Server
     Loaded: loaded (/lib/systemd/system/jenkins.service; enabled; vendor preset: enabled)
     Active: active (running) since Mon 2023-12-04 15:01:35 UTC; 8min ago
   Main PID: 6295 (java)
      Tasks: 37 (limit: 2334)
     Memory: 364.0M
     CGroup: /system.slice/jenkins.service
             └─6295 /usr/bin/java -Djava.awt.headless=true -jar /usr/share/java/jenkins.w>
Dec 04 15:00:55 ip-172-31-93-138 jenkins[6295]: b91a38067a1a4791a61212216e1faff0
Dec 04 15:00:55 ip-172-31-93-138 jenkins[6295]: This may also be found at: /var/lib/jenki>
Dec 04 15:00:55 ip-172-31-93-138 jenkins[6295]: *****************************************>
Dec 04 15:00:55 ip-172-31-93-138 jenkins[6295]: *****************************************>
Dec 04 15:00:55 ip-172-31-93-138 jenkins[6295]: *****************************************>
Dec 04 15:01:35 ip-172-31-93-138 jenkins[6295]: 2023-12-04 15:01:35.610+0000 [id=30]     >
Dec 04 15:01:35 ip-172-31-93-138 jenkins[6295]: 2023-12-04 15:01:35.638+0000 [id=22]     >
Dec 04 15:01:35 ip-172-31-93-138 systemd[1]: Started Jenkins Continuous Integration Serve>
Dec 04 15:01:35 ip-172-31-93-138 jenkins[6295]: 2023-12-04 15:01:35.807+0000 [id=45]     >
Dec 04 15:01:35 ip-172-31-93-138 jenkins[6295]: 2023-12-04 15:01:35.810+0000 [id=45] 

# Unlock Jenkins
# http://44.202.137.122:8080

ubuntu@ip-172-31-93-138:~$ sudo cat /var/lib/jenkins/secrets/initialAdminPassword
somesequrepass-that-i-have-to-pass-somewhere




# Launch Sonarqube Server
# IOanyT Innovations Ubuntu 18.04 Server-cce59db7-36a5-4f61-8cc7-e726f6b484bf
# ami-010b814555e3268fa
> AWS > EC2 > Launch Instance > Name = SonarServer > Ubuntu18.04 >
    t2.medium > sshkey=230724-ec2-t2micro > SG=kops-k8s-SG > 8Gib >
-------
#!/bin/bash

cp /etc/sysctl.conf /root/sysctl.conf_backup
cat <<EOT> /etc/sysctl.conf
vm.max_map_count=262144
fs.file-max=65536
ulimit -n 65536
ulimit -u 4096
EOT

cp /etc/security/limits.conf /root/sec_limit.conf_backup
cat <<EOT> /etc/security/limits.conf
sonarqube   -   nofile   65536
sonarqube   -   nproc    4096
EOT

sudo apt-get update
sudo apt-get install openjdk-11-jdk -y

sudo apt-get update
wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -

sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
sudo apt-get install postgresql postgresql-contrib -y
sudo systemctl enable postgresql.service
sudo systemctl start  postgresql.service
sudo echo "postgres:admin123" | chpasswd
runuser -l postgres -c "createuser sonar"
sudo -i -u postgres psql -c "ALTER USER sonar WITH ENCRYPTED PASSWORD 'admin123';"
sudo -i -u postgres psql -c "CREATE DATABASE sonarqube OWNER sonar;"
sudo -i -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;"
systemctl restart  postgresql

sudo mkdir -p /sonarqube/
cd /sonarqube/
sudo curl -O https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-8.9.10.61524.zip
sudo apt-get install zip -y
sudo unzip -o sonarqube-8.9.10.61524.zip -d /opt/
sudo mv /opt/sonarqube-8.9.10.61524/ /opt/sonarqube
sudo groupadd sonar
sudo useradd -c "SonarQube - User" -d /opt/sonarqube/ -g sonar sonar
sudo chown sonar:sonar /opt/sonarqube/ -R
cp /opt/sonarqube/conf/sonar.properties /root/sonar.properties_backup
cat <<EOT> /opt/sonarqube/conf/sonar.properties
sonar.jdbc.username=sonar
sonar.jdbc.password=admin123
sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
sonar.web.host=0.0.0.0
sonar.web.port=9000
sonar.web.javaAdditionalOpts=-server
sonar.search.javaOpts=-Xmx512m -Xms512m -XX:+HeapDumpOnOutOfMemoryError
sonar.log.level=INFO
sonar.path.logs=logs
EOT

cat <<EOT> /etc/systemd/system/sonarqube.service
[Unit]
Description=SonarQube service
After=syslog.target network.target

[Service]
Type=forking

ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

User=sonar
Group=sonar
Restart=always

LimitNOFILE=65536
LimitNPROC=4096

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl enable sonarqube.service
#systemctl start sonarqube.service
apt-get install nginx -y
rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/sites-available/default
cat <<EOT> /etc/nginx/sites-available/sonarqube
server{
    listen      80;
    server_name sonarqube.groophy.in;

    access_log  /var/log/nginx/sonar.access.log;
    error_log   /var/log/nginx/sonar.error.log;

    proxy_buffers 16 64k;
    proxy_buffer_size 128k;

    location / {
        proxy_pass  http://127.0.0.1:9000;
        proxy_next_upstream error timeout invalid_header http_500 http_502 http_503 http_504;
        proxy_redirect off;
              
        proxy_set_header    Host            \$host;
        proxy_set_header    X-Real-IP       \$remote_addr;
        proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header    X-Forwarded-Proto http;
    }
}
EOT
ln -s /etc/nginx/sites-available/sonarqube /etc/nginx/sites-enabled/sonarqube
systemctl enable nginx.service
sudo ufw allow 80,9000,9001/tcp

echo "System reboot in 30 sec"
sleep 30
reboot
------

# Check SonarQube
* 138 - Server UI Logins
------------------------
[timecode 01:30]

    $ ssh -i "~/.aws/230724-ec2-t2micro.pem" ubuntu@100.26.173.100
||IOanyT Innovations Inc.||
Welcome to Ubuntu 18.04.6 LTS (GNU/Linux 5.4.0-1078-aws x86_64)
...
Last login: Fri Jul  1 06:58:30 2022 from 180.151.238.62
ubuntu@ip-172-31-51-23:~$ sudo systemctl status sonarqube
● sonarqube.service - SonarQube service
   Loaded: loaded (/etc/systemd/system/sonarqube.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2023-12-04 15:19:47 UTC; 1min 32s ago
  Process: 1028 ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start (code=exited, status=0/SUCCESS)
 Main PID: 1123 (wrapper)
    Tasks: 155 (limit: 4680)
   CGroup: /system.slice/sonarqube.service
           ├─1123 /opt/sonarqube/bin/linux-x86-64/./wrapper /opt/sonarqube/bin/linux-x86-64/../../conf/wrapper.conf wrapper.syslog.ident=SonarQube wrapper.pidfile=/opt/sonarqube/bin/linux-x86-
           ├─1142 java -Dsonar.wrapped=true -Djava.awt.headless=true -Xms8m -Xmx32m -Djava.library.path=./lib -classpath ../../lib/sonar-application-8.9.10.61524.jar:../../lib/jsw/wrapper-3.2.
           ├─1407 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -XX:+UseG1GC -Djava.io.tmpdir=/opt/sonarqube/temp -XX:ErrorFile=../logs/es_hs_err_pid%p.log -Des.networkaddress.cache.ttl=60 -Des.
           ├─1554 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djava.io.tmpdir=/opt/sonarqube/temp -XX:-OmitStackTraceInFastThrow --add-opens=jav
           └─1773 /usr/lib/jvm/java-11-openjdk-amd64/bin/java -Djava.awt.headless=true -Dfile.encoding=UTF-8 -Djava.io.tmpdir=/opt/sonarqube/temp -XX:-OmitStackTraceInFastThrow --add-opens=jav

Dec 04 15:19:46 ip-172-31-51-23 systemd[1]: Starting SonarQube service...
Dec 04 15:19:46 ip-172-31-51-23 sonar.sh[1028]: Starting SonarQube...
Dec 04 15:19:47 ip-172-31-51-23 sonar.sh[1028]: Started SonarQube.
Dec 04 15:19:47 ip-172-31-51-23 systemd[1]: Started SonarQube service.

# http://100.26.173.100:80

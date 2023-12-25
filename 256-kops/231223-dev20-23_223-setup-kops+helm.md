# 2023-12-23    17:20
=====================

> AWS > Route 53 > Create hosted Zone > Name=k8v.azrubael.online >
    Public Hosted Zone > *CREATE*

> godaddy.com > Update DNS > *ADD*
NS      ns-1907.awsdns-46.co.uk.
NS      ns-382.awsdns-47.com.
NS      ns-1524.awsdns-62.org.
NS      ns-554.awsdns-05.net.

> godaddy.com > Add Name Servers
ns-1907.awsdns-46.co.uk
ns-382.awsdns-47.com
ns-1524.awsdns-62.org
ns-554.awsdns-05.net

# Kops AWS setup:
- A domain for Kubernetes DNS records (.azrubael.online on godaddy.com)
- A linux VM and setup
    + kubectl
    + ssh keys
    + awscli
    + kops
- AWS account with login and setup:
    + IAM user for awscli (aws-cli)
    + s3 bucket (s3://k8v-azrubael-online)
    + Route53 Hosted Zone which will be our subdomain
- Login to Domain Registrar
    After creating the Hosted Zone we're going to give its entry
- Create four NS records for subdomain pointing to Route 53 hosted zone NS servers
https://k8v.azrubael.online


* 223 - Kops for K8s Setup
--------------------------

> AWS > EC2 > Launch instance > name=kops-k8s > Ubuntu22.04 > t2.micro >
    kops-k8s-SG=[ssh:myIP,] > 230724-ec2-t2micro.pem > *Launch instance*


    $ ssh -i "~/.aws/230724-ec2-t2micro.pem" ubuntu@3.91.221.88
sudo hostnamectl set-hostname k8v-kops
ubuntu@k8v-kops:~$ ssh-keygen -N "" -f $HOME/.ssh/id_rsa

ubuntu@k8v-kops:~$ sudo apt install awscli -y
ubuntu@k8v-kops:~$ sudo apt update
...

ubuntu@k8v-kops:~$ aws configure
# [aws-cli]

ubuntu@k8v-kops:~$ curl -LO https://dl.k8s.io/release/v1.28.4/bin/linux/amd64/kubectl
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   138  100   138    0     0   1007      0 --:--:-- --:--:-- --:--:--  1014
100 47.5M  100 47.5M    0     0  76.8M      0 --:--:-- --:--:-- --:--:--  140M

ubuntu@k8v-kops:~$ curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   138  100   138    0     0   1093      0 --:--:-- --:--:-- --:--:--  1095
100    64  100    64    0     0    285      0 --:--:-- --:--:-- --:--:--   285

ubuntu@k8v-kops:~$ ls -l
total 48720
-rw-rw-r-- 1 ubuntu ubuntu 49885184 Dec 18 08:59 kubectl
-rw-rw-r-- 1 ubuntu ubuntu       64 Dec 18 08:59 kubectl.sha256
ubuntu@k8v-kops:~$ sudo chmod +x ./kubectl kubectl.sha256
ubuntu@k8v-kops:~$ sudo mv * /usr/local/bin/

ubuntu@k8v-kops:~$ kubectl version
Client Version: v1.28.4
Kustomize Version: v5.0.4-0.20230601165947-6ce0bf390ce3
The connection to the server localhost:8080 was refused - did you specify the right host or port?


# Installing Kubernetes with kOps
# https://kubernetes.io/docs/setup/production-environment/tools/kops/
ubuntu@k8v-kops:~$ curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100  176M  100  176M    0     0   105M      0  0:00:01  0:00:01 --:--:--  115M

ubuntu@k8v-kops:~$ ls -l
total 180876
-rw-rw-r-- 1 ubuntu ubuntu 185216172 Dec 18 09:06 kops-linux-amd64

ubuntu@k8v-kops:~$ sudo chmod +x kops-linux-amd64
ubuntu@k8v-kops:~$ sudo mv kops-linux-amd64 /usr/local/bin/kops
ubuntu@k8v-kops:~$ kops version
Client version: 1.28.1 (git-v1.28.1)

ubuntu@k8v-kops:~$ nslookup -type=ns k8v.azrubael.online
Server:		127.0.0.53
Address:	127.0.0.53#53
    Non-authoritative answer:
k8v.azrubael.online	nameserver = ns-1524.awsdns-62.org.
k8v.azrubael.online	nameserver = ns-1907.awsdns-46.co.uk.
k8v.azrubael.online	nameserver = ns-382.awsdns-47.com.
k8v.azrubael.online	nameserver = ns-554.awsdns-05.net.
    Authoritative answers can be found from:

ubuntu@k8v-kops:~$ aws configure set aws_access_key_id $awsaccess
ubuntu@k8v-kops:~$ aws configure set aws_secret_access_key $awssecret
ubuntu@k8v-kops:~$ aws s3 mb s3://$clname
make_bucket: k8v.azrubael.online

# This command creates a configuration for the kubernetes cluster and stores into AWS S3 BUCKET
ubuntu@k8v-kops:~$ kops create cluster --name=k8v.azrubael.online \
--state=s3://k8v.azrubael.online \
--zones=us-east-1a,us-east-1b \
--node-count=2 --node-size=t2.micro \
--control-plane-size=t2.micro \
--dns-zone=k8v.azrubael.online --yes
I1219 11:08:05.827560    3346 new_cluster.go:1373] Cloud Provider ID: "aws"
I1219 11:08:05.931497    3346 subnets.go:224] Assigned CIDR 172.20.0.0/17 to subnet us-east-1a
I1219 11:08:05.931685    3346 subnets.go:224] Assigned CIDR 172.20.128.0/17 to subnet us-east-1b
I1219 11:08:11.587322    3346 executor.go:111] Tasks: 0 done / 113 total; 45 can run
W1219 11:08:11.741435    3346 vfs_keystorereader.go:143] CA private key was not found
I1219 11:08:11.775826    3346 keypair.go:226] Issuing new certificate: "etcd-peers-ca-main"
W1219 11:08:11.815915    3346 vfs_keystorereader.go:143] CA private key was not found
I1219 11:08:11.816343    3346 keypair.go:226] Issuing new certificate: "etcd-manager-ca-main"
I1219 11:08:11.835430    3346 keypair.go:226] Issuing new certificate: "etcd-manager-ca-events"
I1219 11:08:11.854960    3346 keypair.go:226] Issuing new certificate: "etcd-clients-ca"
I1219 11:08:11.875167    3346 keypair.go:226] Issuing new certificate: "apiserver-aggregator-ca"
I1219 11:08:11.895285    3346 keypair.go:226] Issuing new certificate: "etcd-peers-ca-events"
I1219 11:08:12.037291    3346 keypair.go:226] Issuing new certificate: "kubernetes-ca"
I1219 11:08:12.469536    3346 keypair.go:226] Issuing new certificate: "service-account"
I1219 11:08:14.241604    3346 executor.go:111] Tasks: 45 done / 113 total; 25 can run
I1219 11:08:15.242274    3346 executor.go:111] Tasks: 70 done / 113 total; 31 can run
I1219 11:08:16.345372    3346 executor.go:111] Tasks: 101 done / 113 total; 3 can run
I1219 11:08:17.412973    3346 executor.go:155] No progress made, sleeping before retrying 3 task(s)
I1219 11:08:27.413433    3346 executor.go:111] Tasks: 101 done / 113 total; 3 can run
I1219 11:08:28.785545    3346 executor.go:111] Tasks: 104 done / 113 total; 9 can run
I1219 11:08:29.039968    3346 executor.go:111] Tasks: 113 done / 113 total; 0 can run
I1219 11:08:29.207935    3346 dns.go:235] Pre-creating DNS records
I1219 11:08:29.312260    3346 update_cluster.go:322] Exporting kubeconfig for cluster
    kOps has set your kubectl context to k8v.azrubael.online
    Cluster is starting.  It should be ready in a few minutes.
    Suggestions:
 * validate cluster: kops validate cluster --wait 10m
 * list nodes: kubectl get nodes --show-labels
 * ssh to a control-plane node: ssh -i ~/.ssh/id_rsa ubuntu@api.k8v.azrubael.online
 * the ubuntu user is specific to Ubuntu. If not using Ubuntu please use the appropriate user based on your OS.
 * read about installing addons at: https://kops.sigs.k8s.io/addons.

ubuntu@k8v-kops:~$ date
        Tue Dec 19 11:14:37 AM UTC 2023

ubuntu@k8v-kops:~$ kops update cluster --name k8v.azrubael.online --state=s3://k8v.azrubael.online --yes --admin
I1219 11:12:26.846170    3353 executor.go:111] Tasks: 0 done / 113 total; 45 can run
I1219 11:12:27.361049    3353 executor.go:111] Tasks: 45 done / 113 total; 25 can run
I1219 11:12:27.585051    3353 executor.go:111] Tasks: 70 done / 113 total; 31 can run
I1219 11:12:28.265571    3353 executor.go:111] Tasks: 101 done / 113 total; 3 can run
I1219 11:12:28.387295    3353 executor.go:111] Tasks: 104 done / 113 total; 9 can run
I1219 11:12:28.490754    3353 executor.go:111] Tasks: 113 done / 113 total; 0 can run
I1219 11:12:28.691378    3353 dns.go:235] Pre-creating DNS records
I1219 11:12:28.692705    3353 update_cluster.go:322] Exporting kubeconfig for cluster
    kOps has set your kubectl context to k8v.azrubael.online
    Cluster changes have been applied to the cloud.
    Changes may require instances to restart: kops rolling-update cluster
ubuntu@k8v-kops:~$ date
        Mon Dec 18 03:05:33 PM UTC 2023

ubuntu@k8v-kops:~$ kops get cluster --state=s3://k8v.azrubael.online
NAME			CLOUD	ZONES
k8v.azrubael.online	aws	us-east-1a,us-east-1b

ubuntu@k8v-kops:~$ kops get all --name k8v.azrubael.online --state=s3://k8v.azrubael.online
    Cluster
NAME			CLOUD	ZONES
k8v.azrubael.online	aws	us-east-1a,us-east-1b
    Instance Groups
NAME				ROLE		MACHINETYPE	MIN	MAX	ZONES
control-plane-us-east-1a	ControlPlane	t2.micro	1	1	us-east-1a
nodes-us-east-1a		Node		t2.micro	1	1	us-east-1a
nodes-us-east-1b		Node		t2.micro	1	1	us-east-1b

ubuntu@k8v-kops:~$ kops validate cluster --name k8v.azrubael.online --state=s3://k8v.azrubael.online --wait 10m --count 3


kops delete cluster --name k8v.azrubael.online --state=s3://k8v.azrubael.online --yes
        Deleted cluster: "k8v.azrubael.online"


# 2023-12-23    17:56
=====================

# Installing Helm
# https://helm.sh/
# Helm is basically is a packaging system for definition files.
# So we can package all the definitions for our project stack, and we can also deploy it to Kubernetes cluster.
# Helm helps us manage Kubernetes applications.
# Helm charts help to define, install and upgrade the most complex Kubernetes application.
# After that we're going to install Helm on our kops-k8s WAS EC2 instance.

curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm


ubuntu@ip-172-31-27-187:~$ helm version
version.BuildInfo{Version:"v3.13.2", GitCommit:"2a2fb3b98829f1e0be6fb18af2f6599e0f4e8243", GitTreeState:"clean", GoVersion:"go1.20.10"}

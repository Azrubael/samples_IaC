# 2023-11-27    14:19
=====================

* 244 - Introduction
--------------------
This project is about a Web Application on Kubernetes Cluster
So we have an orchestration tool Kubernetes.

1. SCENARIO
- We have a multi tier Web Application Stack;
- All the parts of our application are conteinerized;
- We're going to use 'vprofile' web applicatopn which we containerized in our previous projects;
- We have also already tested it;
- Now it's time to host it for production.

Running containers for production is little different.

2. REQUIREMENT
- High availability
    So your containers haven't go down 
- Fault tolerance 
    Your Compute node requirement is also for fault tolerance.
    It something happens to the containers and they are not responding, they should also auto heal.
- Easy scalable
    It should be also convenient to scale containers and also the compute resource on which your containers are running
- Platform independent
- Portable, flexible, agile.
    So we should be able to run our containers on local cloud, VMs, physical machines and should be able to run in different environments (QA, dev, prod) easily and conveniently.

3. TECHNOLOGIES
- Kubernetes cluster
- Java stack application

4. STEPS
- Kubernetes cluster
- Containerized Application 'vprofile'
    MySQL container that needs a volume to store its persistent data
- AWS EBS volume for MySQL Pod
- LABEL Node with zones names
    We're going to create EBS volume in a zone and we need our pod to be running on the same zone where we created the EBS volume.
- We're going to write Kubernetes Definition files (manifests) to create our objects on Kubernetes cluster
- We're going to use:
    + Deployment
    + Service
    + Secret
    + Volume

- 




# 2023-11-25    14:03
=====================

* 230 - Replica Set
-------------------
# https://kubernetes.io/ru/docs/reference/kubectl/cheatsheet/
# https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/

ReplicaSet is often used to guarantee the availability of a specified number of identical Pods.
A ReplicaSet ensures that a specified number of pod replicas are running at any given time. However, a Deployment is a higher-level concept that manages ReplicaSets and provides declarative updates to Pods along with a lot of other useful features. Therefore, we recommend using Deployments instead of directly using ReplicaSets, unless you require custom update orchestration or don't require updates at all.
This actually means that you may never need to manipulate ReplicaSet objects: use a Deployment instead, and define your application in the spec section.

# just for example
    $ vim replset.yml
---
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: frontend
  labels:
    app: guestbook
    tier: frontend
spec:
  # modify replicas according to your case
  replicas: 3
  selector:
    matchLabels:
      tier: frontend
  template:
    metadata:
      labels:
        tier: frontend
    spec:
      containers:
      - name: php-redis
        image: gcr.io/google_samples/gb-frontend:v3


    $ kubectl create -f 230-replicaset.yml
replicaset.apps/frontend created
    $ kubectl get all
NAME                 READY   STATUS              RESTARTS   AGE
pod/frontend-btlnd   0/1     ContainerCreating   0          12s
pod/frontend-dkb2m   0/1     ContainerCreating   0          12s
pod/frontend-pvph7   0/1     ContainerCreating   0          12s

NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   24h

NAME                       DESIRED   CURRENT   READY   AGE
replicaset.apps/frontend   3         3         0       12s

    $ kubectl get rs
NAME       DESIRED   CURRENT   READY   AGE
frontend   3         3         3       50s
    $ kubectl get pod
NAME             READY   STATUS    RESTARTS   AGE
frontend-btlnd   1/1     Running   0          83s
frontend-dkb2m   1/1     Running   0          83s
frontend-pvph7   1/1     Running   0          83s

    $ kubectl delete pod frontend-btlnd frontend-dkb2m
pod "frontend-btlnd" deleted
pod "frontend-dkb2m" deleted
    $ kubectl get pod
NAME             READY   STATUS    RESTARTS   AGE

frontend-58nj4   1/1     Running   0          2s    <--- the new one
frontend-g2s2m   1/1     Running   0          2s    <--- the new one
frontend-pvph7   1/1     Running   0          4m1s

***********************************************
# The imperative syntax (without a manifest)
    $ kubectl scale --replicas=1 rs/fronted
# OR
    $ kubectl edit rs frontend
    $ kubectl delete rs frontend
***********************************************

    $ kubectl delete -f 230-replicaset.yml
replicaset.apps "frontend" deleted
    $ kubectl get all
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   24h


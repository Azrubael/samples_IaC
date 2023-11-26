# 2023-11-25    15:06
=====================

* 231 - Deployment
------------------
# https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

A *Deployment* controller provides declarative updates for Pods and ReplicaSets.
Define `desired state` in a *Deployment* and the Deployment controller changes the actual state to the desired state at a controlled rate.
Deployment creates ReplicaSet to manage number of pods.
Changes on the pod will always happen by deleting the existing pod and creating a new pod.
*Deployment* is the most useful ibject for DevOps.

Use cases
- *Create a Deployment to rollout a ReplicaSet.* The ReplicaSet creates Pods in the background. Check the status of the rollout to see if it succeeds or not.
- *Declare the new state of the Pods* by updating the PodTemplateSpec of the Deployment. A new ReplicaSet is created and the Deployment manages moving the Pods from the old ReplicaSet to the new one at a controlled rate. Each new ReplicaSet updates the revision of the Deployment.
- *Rollback to an earlier Deployment revision* if the current state of the Deployment is not stable. Each rollback updates the revision of the Deployment.
- *Scale up the Deployment to facilitate more load.*
- *Pause the rollout of a Deployment* to apply multiple fixes to its PodTemplateSpec and then resume it to start a new rollout.
- *Use the status of the Deployment* as an indicator that a rollout has stuck.
- *Clean up older ReplicaSets* that you don't need anymore.

# just a sample of a deployment manifest
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-controller
spec:
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: tomcat-controller
        image: tomcat
        ports:
        - name: app-port
          containerPort: 8080
  replicas: 3
  selector:
    matchLabels:
      app: backend



-------
    $ vim 231-nginx-depl.yml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.14.2
        ports:
        - containerPort: 80

-------

    $ kubectl apply -f 231-nginx-depl.yml
deployment.apps/nginx-deployment created
    $ kubectl get deploy
NAME               READY   UP-TO-DATE   AVAILABLE   AGE
nginx-deployment   3/3     3            3           2m20s
    $ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-86dcfdf4c6   3         3         3       2m58s

    $ kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/nginx-deployment-86dcfdf4c6-d8fmv   1/1     Running   0          90s
pod/nginx-deployment-86dcfdf4c6-sg2pm   1/1     Running   0          90s
pod/nginx-deployment-86dcfdf4c6-z8jpg   1/1     Running   0          90s
NAME                 TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.96.0.1    <none>        443/TCP   25h
NAME                               READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/nginx-deployment   3/3     3            3           93s
NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/nginx-deployment-86dcfdf4c6   3         3         3       91s

$ kubectl describe pod nginx-deployment-86dcfdf4c6-sg2pm
...
Events:
  Type    Reason     Age    From               Message
  ----    ------     ----   ----               -------
  Normal  Scheduled  3m41s  default-scheduler  Successfully assigned default/nginx-deployment-86dcfdf4c6-sg2pm to docker-desktop
...

# you can update the deployment manually
    $ kubectl set image deployment/nginx-deployment nginx=nginx:1.16.1
deployment.apps/nginx-deployment image updated
    $ kubectl describe deployment nginx-deployment
...
    Image:        nginx:1.16.1
...
Events:
  Type    Reason             Age    From                   Message
  ----    ------             ----   ----                   -------
  Normal  ScalingReplicaSet  7m51s  deployment-controller  Scaled up replica set nginx-deployment-86dcfdf4c6 to 3
  Normal  ScalingReplicaSet  40s    deployment-controller  Scaled up replica set nginx-deployment-848dd6cfb5 to 1
  Normal  ScalingReplicaSet  21s    deployment-controller  Scaled down replica set nginx-deployment-86dcfdf4c6 to 2 from 3
  Normal  ScalingReplicaSet  21s    deployment-controller  Scaled up replica set nginx-deployment-848dd6cfb5 to 2 from 1
  Normal  ScalingReplicaSet  18s    deployment-controller  Scaled down replica set nginx-deployment-86dcfdf4c6 to 1 from 2
  Normal  ScalingReplicaSet  18s    deployment-controller  Scaled up replica set nginx-deployment-848dd6cfb5 to 3 from 2
  Normal  ScalingReplicaSet  15s    deployment-controller  Scaled down replica set nginx-deployment-86dcfdf4c6 to 0 from 1

    $ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-848dd6cfb5   3         3         3       4m40s
nginx-deployment-86dcfdf4c6   0         0         0       11m   <--- stopped

    $ kubectl rollout undo deployment/nginx-deployment
deployment.apps/nginx-deployment rolled back
    $ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-848dd6cfb5   1         1         1       7m43s
nginx-deployment-86dcfdf4c6   3         3         2       14m
    $ kubectl get rs
NAME                          DESIRED   CURRENT   READY   AGE
nginx-deployment-848dd6cfb5   0         0         0       8m24s
nginx-deployment-86dcfdf4c6   3         3         3       15m

    $ kubectl get pod
NAME                                READY   STATUS    RESTARTS   AGE
nginx-deployment-86dcfdf4c6-42dxw   1/1     Running   0          91s
nginx-deployment-86dcfdf4c6-8sml2   1/1     Running   0          95s
nginx-deployment-86dcfdf4c6-ztcdm   1/1     Running   0          93s
    $ kubectl describe pod nginx-deployment-86dcfdf4c6-42dxw | grep image
Normal  Pulled     2m58s  kubelet            Container image "nginx:1.14.2" already present on machine


$ kubectl rollout history deployment/nginx-deployment
deployment.apps/nginx-deployment 
REVISION  CHANGE-CAUSE
2         <none>
3         <none>


*IMPERATIVE COMMANDS ARE ONLY FOR TESTING PURPOSE*
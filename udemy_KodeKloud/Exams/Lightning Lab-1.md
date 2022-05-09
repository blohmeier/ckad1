<details><summary>Exam link</summary>
https://kodekloud.com/topic/lightning-lab-1-4/
</p></details>

### Check 1 ###
<details><summary>
Create a Persistent Volume called log-volume. It should make use of a storage class name manual. It should use RWX as the access mode and have a size of 1Gi. The volume should use the hostPath /opt/volume/nginx
Next, create a PVC called log-claim requesting a minimum of 200Mi of storage. This PVC should bind to log-volume.
Mount this in a pod called logger at the location /var/www/nginx. This pod should use the image nginx:alpine.
</summary>
<p>
  
```bash
vim 1_pv.yml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: log-volume
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  storageClassName: manual
  hostPath:
    path: "opt/volume/nginx"

k create -f 1_pv.yml
vim 1_pvc.yml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: log-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 200Mi

k create -f 1_pvc.yml
k run logger --image=nginx:alpine $dy > 1_pod.yml
vim 1_pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: logger
spec:
  containers:
    - name: logger
      image: nginx:alpine
      volumeMounts:
        - name: config
          mountPath: /var/www/nginx
  volumes:
    - name: config
      persistentVolumeClaim:
        claimName: log-clai
```
  
</p>
</details>

### Check 2 ###
We have deployed a new pod called secure-pod and a service called secure-service. Incoming or Outgoing connections to this pod are not working. 
Troubleshoot why this is happening.
Make sure that incoming connection from the pod webapp-color are successful.

<details><summary>show</summary><p>

```bash
k get svc
k exec -it webapp-color -- sh
nc -zvw 1 secure-service 80
k get netpol default-deny -o yaml > 2_netpol.yml
vim 2_netpol.yml #Final config follows

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-webapp-color
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              name: webapp-color
      ports:
        - protocol: TCP 
          port: 80

k create -f 2_netpol.yml

k exec -it webapp-color -- sh
nc -z -v -w 1 secure-service 80  
```
</p>
</details>

### Check 3 ###
Create a pod called time-check in the dvl1987 namespace. This pod should run a container called time-check that uses the busybox image. 
Create a config map called time-config with the data TIME_FREQ=10 in the same namespace.
The time-check container should run the command: while true; do date; sleep $TIME_FREQ;done and write the result to the location /opt/time/time-check.log.
The path /opt/time on the pod should mount a volume that lasts the lifetime of this pod.

<details><summary>show</summary>
<p>
  
```bash
k -get ns
k create ns dvl1987
k run -n dvl1987 time-check --image=busybox $dy --command -- "while true; do date; sleep $TIME_FREQ; done"
```
</p>
</details>

### Check 4 ###
Create a new deployment called nginx-deploy, with one single container called nginx, image nginx:1.16 and 4 replicas. The deployment should use RollingUpdate strategy with maxSurge=1, and maxUnavailable=2.
Next upgrade the deployment to version 1.17.
Finally, once all pods are updated, undo the update and go back to the previous version.

<details><summary>show</summary>
<p>
  
```bash
k create deploy nginx-deploy --image=nginx:1.16 --replicas=4 $dy > 4.yml
k apply -f 4.yml

#edit at .spec.strategy:
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 2

k set image deploy nginx-deploy nginx=nginx:1.17deployment.apps/nginx-deploy image updated
k rollout undo deploy nginx-deploy
```
</p>
</details>

### Check 5 ###
<p>Create a redis deployment with the following parameters:
Name of the deployment should be redis using the redis:alpine image. It should have exactly 1 replica.
The container should request for .2 CPU. It should use the label app=redis.
It should mount exactly 2 volumes.

a. An Empty directory volume called data at path /redis-master-data.
b. A configmap volume called redis-config at path /redis-master.
c. The container should expose the port 6379. 
The configmap has already been created.</p>
<details><summary>show</summary>
<p>
  
```bash
vim 5.yml

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: redis
  name: redis
spec:
  selector:
    matchLabels:
      app: redis
  template:
    metadata:
      labels:
        app: redis
    spec:
      volumes:
      - name: data
        emptyDir: {}
      - name: config
        configMap:
          name: redis-config
      containers:
      - image: redis:alpine
        name: redis
        volumeMounts:
        - mountPath: /redis-master-data
          name: data
        - mountPath: /redis-master
          name: config
        ports:
        - containerPort: 6379
        resources:
          requests:
            cpu: "0.2"
```
</p>
</details>

### Check 6 ###


#TEMPLATE
<details><summary>show</summary>
<p>
  
```bash

```
</p>
</details>

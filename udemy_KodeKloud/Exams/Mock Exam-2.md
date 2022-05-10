<details><summary>Exam link</summary>
https://kodekloud.com/topic/mock-exam-2-5/
</p></details>

<details><summary>vim config</summary>
<p>
  
```bash
export dy='--dry-run=client -o yaml' fg='--force --grace-period 0' && \
alias k=kubectl && source <(kubectl completion bash | sed 's/kubectl/k/g') && \
echo "source <(kubectl completion bash)" >> $HOME/.bashrc && \
echo -e 'set et nu sts=2 sw=2 ts=2 ' >> ~/.vimrc
EXPLAINED
set expandtab #never see \t again in your file - expands tab keypresses to space
set number
set softtabstop #of whitespace cols a tab/backspace keypress is worth
set shiftwidth=2 #of whitespace cols a "lvl of indent" is worth
set tabstop=2 #of whitespace cols a tab counts for

```
</p>
</details>

### Check 1 ###
<details><summary>
Create a deployment called my-webapp with image: nginx, label tier:frontend and 2 replicas. Expose the deployment as a NodePort service with name front-end-service, port: 80 and NodePort: 30083.
</summary>
<p>
  
```bash
k create deploy my-webapp --image=nginx --replicas=2
k label deploy my-webapp tier=frontend
vim 1_svc.yml
apiVersion: v1
kind: Service
metadata:
  name: front-end-service
spec:
  type: NodePort
  selector:
    tier: frontend
  ports:
    - port: 80
      nodePort: 30083
k create -f 1_svc.yml
```
</p>
</details>

### Check 2 ###
<details><summary>
Add a taint to the node node01 of the cluster. Use the specification below:
key: app_type, value: alpha and effect: NoSchedule
Create a pod called alpha, image: redis with toleration to node01.
</summary>
<p>
  
```bash
k taint node node01 app_type=alpha:NoSchedule
k run alpha --image=redis $dy > 2.yml
vim 2.yml
apiVersion: v1
kind: Pod 
metadata:
  creationTimestamp: null
  labels:
    run: alpha
  name: alpha
spec:
  tolerations:
  - effect: NoSchedule
    key: app_type
    value: alpha
  containers:
  - image: redis
    name: alpha
k create -f 2.yml

```
</p>
</details>

### Check 3 ###
<details><summary>
Create a new Deployment named httpd-frontend with 3 replicas using image httpd:2.4-alpine.
</summary>
<p>
  
```bash
k create deploy httpd-frontend --image=httpd:2.4-alpine --replicas=3
```
</p>
</details>

### Check 4 ###
<details><summary>
Deploy a messaging pod using the redis:alpine image with the labels set to tier=msg.
</summary>
<p>
  
```bash
k run messaging --image=redis:alpine --labels=tier=msg
```
</p>
</details>

### Check 5 ###
<details><summary>
A replicaset rs-d33393 is created. However the pods are not coming up. Identify and fix the issue.
Once fixed, ensure the ReplicaSet has 4 Ready replicas.
</summary>
<p>
  
```bash

```
</p>
</details>

### Check 6 ###
<details><summary>
Create a service messaging-service to expose the redis deployment in the marketing namespace within the cluster on port 6379.
</summary>
<p>
  
```bash

```
</p>
</details>

### Check 7 ###
<details><summary>
Update the environment variable on the pod webapp-color to use a green background.
</summary>
<p>
  
```bash
k edit pod webapp-color #Change "pink" to "green"
k delete pod webapp-color $fg
k create -f /tmp/kubectl-edit-___.yaml
```
</p>
</details>

### Check 8 ###
<details><summary>
Create a new ConfigMap named cm-3392845. Use the spec given on the below.
ConfigName Name: cm-3392845
Data: DB_NAME=SQL3322
Data: DB_HOST=sql322.mycompany.com
Data: DB_PORT=3306
</summary>
<p>
  
```bash
k create cm cm-3392845
k edit cm cm-3392845
apiVersion: v1
kind: ConfigMap
metadata:
  name: cm-3392845
data:
  DB_HOST: sql322.mycompany.com
  DB_NAME: SQL3322
  DB_PORT: "3306"
```
</p>
</details>

### Check 9 ###
<details><summary>
Create a new Secret named db-secret-xxdf with the data given (on the below).
Secret Name: db-secret-xxdf
Secret 1: DB_Host=sql01
Secret 2: DB_User=root
Secret 3: DB_Password=password123
</summary>
<p>
  
```bash
k create secret generic db-secret-xxdf --from-literal='DB_Host=sql01,DB_User=root,DB_Password=password123'
```
</p>
</details>

### Check 10 ###
<details><summary>
Update pod app-sec-kff3345 to run as Root user and with the SYS_TIME capability.
Pod Name: app-sec-kff3345
Image Name: ubuntu
SecurityContext: Capability SYS_TIME
</summary>
<p>
  
```bash
```
</p>
</details>

### Check 11 ###
<details><summary>
Export the logs of the e-com-1123 pod to the file /opt/outputs/e-com-1123.logs
It is in a different namespace. Identify the namespace first.
</summary>
<p>
  
```bash
k get pods -A
k logs -n e-commerce e-com-1123 > /opt/outputs/e-com-1123.logs
```
</p>
</details>

### Check 12 ###
<details><summary>
Create a Persistent Volume with the given specification.
Volume Name: pv-analytics
Storage: 100Mi
Access modes: ReadWriteMany
Host Path: /pv/data-analytics
</summary>
<p>
  
```bash
vim 12.yml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-analytics
spec:
  capacity:
    storage: 100Mi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: "/pv/data-analytics"
k create -f 12.yml
```
</p>
</details>

### Check 13 ###
<details><summary>
Create a redis deployment using the image redis:alpine with 1 replica and label app=redis. Expose it via a ClusterIP service called redis on port 6379. Create a new Ingress Type NetworkPolicy called redis-access which allows only the pods with label access=redis to access the deployment.
</summary>
<p>
  
```bash
k create deployment redis --image=redis:alpine --replicas=1
k expose deployment redis --name=redis --port=6379 --target-port=6379
vim 13_netpol.yml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: redis-access
  namespace: default
spec:
  podSelector:
    matchLabels:
       app: redis
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: redis
    ports:
     - protocol: TCP
       port: 6379
k create -f 13_netpol.yml
```
</p>
</details>

### Check 14 ###
<details><summary>
Create a Pod called sega with two containers:
Container 1: Name tails with image busybox and command: sleep 3600.
Container 2: Name sonic with image nginx and Environment variable: NGINX_PORT with the value 8080.
</summary>
<p>
  
```bash
vim 14.yml
apiVersion: v1
kind: Pod
metadata:
  name: sega
spec:
  containers:
  - image: busybox
    name: tails
    command:
    - sleep
    - "3600"
  - image: nginx
    name: sonic
    env:
    - name: NGINX_PORT
      value: "8080"
k create -f 14.yml
```
</p>
</details>

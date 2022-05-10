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
OR
cat << EOF | k apply -f -
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
EOF
OR
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
Apply a label app_type=beta to node controlplane. Create a new deployment called beta-apps with image: nginx and replicas: 3. Set Node Affinity to the deployment to place the PODs on controlplane only.
NodeAffinity: requiredDuringSchedulingIgnoredDuringExecution
</summary>
<p>
  
```bash
k label node controlplane app_type=beta
k create deploy beta-apps --image=nginx --replicas=3 $dy > 3.yml
vim 3.yml #add below under .spec.template.spec
      affinity:
        nodeAffinity:
         requiredDuringSchedulingIgnoredDuringExecution:
           nodeSelectorTerms:
           - matchExpressions:
             - key: app_type
               values: ["beta"]
               operator: In
k create -f 3.yml
```
</p>
</details>

### Check 4 ###
<details><summary>
Create a new Ingress Resource for the service: my-video-service to be made available at the URL: http://ckad-mock-exam-solution.com:30093/video.
Create an ingress resource with host: ckad-mock-exam-solution.com
path: /video
Once set up, curl test of the URL from the nodes should be successful / HTTP 200
</summary>
<p>
  
```bash
k create ingress ingress --rule="ckad-mock-exam-solution.com/video*=my-video-service:8080"

```
</p>
</details>

### Check 5 ###
<details><summary>
We have deployed a new pod called pod-with-rprobe. This Pod has an initial delay before it is Ready. Update the newly created pod pod-with-rprobe with a readinessProbe using the given spec
httpGet path: /ready
httpGet port: 8080
</summary>
<p>
  
```bash
k get pod pod-with-rprobe -o yaml > 5.yml
vim 5.yml
spec:
  containers:
  - env:
    - name: APP_START_DELAY
      value: "180"
    image: kodekloud/webapp-delayed-start
    imagePullPolicy: Always
    name: pod-with-rprobe
    ports:
    - containerPort: 8080
      protocol: TCP 
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
k delete pod pod-with-rprobe $fg
k create -f 5.yml
```
</p>
</details>

### Check 6 ###
<details><summary>
Create a new pod called nginx1401 in the default namespace with the image nginx. Add a livenessProbe to the container to restart it if the command ls /var/www/html/probe fails. This check should start after a delay of 10 seconds and run every 60 seconds.
You may delete and recreate the object. Ignore the warnings from the probe.
</summary>
<p>
  
```bash
k run nginx1401 --image=nginx $dy > 6.yml
vim 6.yml
apiVersion: v1
kind: Pod 
metadata:
  creationTimestamp: null
  labels:
    run: nginx1401
  name: nginx1401
spec:
  containers:
  - image: nginx
    name: nginx1401
    livenessProbe:
      exec:
        command:
        - ls
        - /var/www/html/probe
      initialDelaySeconds: 10
      periodSeconds: 60
k create -f 6.yml
```
</p>
</details>

### Check 7 ###
<details><summary>
Create a job called whalesay with image docker/whalesay and command "cowsay I am going to ace CKAD!".
completions: 10
backoffLimit: 6
restartPolicy: Never
This simple job runs the popular cowsay game that was modifed by docker…
</summary>
<p>
  
```bash
vim 7.yml
OR
cat << EOF | k apply -f -
apiVersion: batch/v1
kind: Job
metadata:
  name: whalesay
spec:
  completions: 10
  backoffLimit: 6
  template:
    metadata:
      creationTimestamp: null
    spec:
      containers:
      - command:
        - sh 
        - -c
        - "cowsay I am going to ace CKAD!"
        image: docker/whalesay
        name: whalesay
      restartPolicy: Never
EOF
OR
k create -f 7.yml
```
</p>
</details>

### Check 8 ###
<details><summary>
Create a pod called multi-pod with two containers. 
Container 1: 
name: jupiter, image: nginx
Container 2: 
name: europa, image: busybox
command: sleep 4800
Environment Variables: 
Container 1: 
type: planet
Container 2: 
type: moon
</summary>
<p>
  
```bash
vim 8.yml
OR
cat << EOF | k apply -f -
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: multi-pod
  name: multi-pod
spec:
  containers:
  - image: nginx
    name: jupiter
    env:
    - name: type
      value: planet
  - image: busybox
    name: europa
    command: ["/bin/sh","-c","sleep 4800"]
    env:
     - name: type
       value: moon
EOF
OR
k create -f 8.yml
```
</p>
</details>

### Check 9 ###
<details><summary>
Create a PersistentVolume called custom-volume with size: 50MiB reclaim policy:retain, Access Modes: ReadWriteMany and hostPath: /opt/data.
</summary>
<p>
  
```bash
vim 9.yml
OR
cat << EOF | k apply -f -
kind: PersistentVolume
apiVersion: v1
metadata:
  name: custom-volume
spec:
  accessModes: ["ReadWriteMany"]
  capacity:
    storage: 50Mi
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /opt/data
EOF
OR
k create -f 9.yml
```
</p>
</details>

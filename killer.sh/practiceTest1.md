<details><summary>Exam link</summary>
?
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

### Q1 | Namespaces ###
<details><summary>
The DevOps team would like to get the list of all Namespaces in the cluster. Get the list and save it to /opt/course/1/namespaces.
</summary>
<p>
  
```bash
k get ns > /opt/course/1/namespaces
  
```
</p>
</details>

### Q2 | Pods ###
<details><summary>
Create a single Pod of image httpd:2.4.41-alpine in Namespace default. The Pod should be named pod1 and the container should be named pod1-container.
Your manager would like to run a command manually on occasion to output the status of that exact Pod. Please write a command that does this into /opt/course/2/pod1-status-command.sh. The command should use kubectl.
</summary>
<p>
  
```bash
k run pod1 --image=httpd:2.4.41-alpine $dy > 2.yaml
vim 2.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod1
  name: pod1
spec:
  containers:
  - image: httpd:2.4.41-alpine
    name: pod1-container # change
k create -f 2.yml
k get pod pod1 -o jsonpath="{.status.phase}" > /opt/course/2/pod1-status-command.sh
```
</p>
</details>

### Q3 | Job ###
<details><summary>
Team Neptune needs a Job template located at /opt/course/3/job.yaml. This Job should run image busybox:1.31.0 and execute sleep 2 && echo done. It should be in namespace neptune, run a total of 3 times and should execute 2 runs in parallel.
Start the Job and check its history. Each pod created by the Job should have the label id: awesome-job. The job should be named neb-new-job and the container neb-new-job-container.
</summary>
<p>
  
```bash
k -n neptune create job neb-new-job --image=busybox:1.31.0 $dy > /opt/course/3/job.yaml -- sh -c "sleep 2 && echo done"
vim /opt/course/3/job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: neb-new-job
  namespace: neptune      # add
spec:
  completions: 3          # add
  parallelism: 2          # add
  template:
    metadata:
      creationTimestamp: null
      labels:             # add
        id: awesome-job   # add
    spec:
      containers:
      - command:
        - sh
        - -c
        - sleep 2 && echo done
        image: busybox:1.31.0
        name: neb-new-job-container # update
k create -f /opt/course/3/job.yaml
```
</p>
</details>

### Q4 | Helm Management ###
<details><summary>
Team Mercury asked you to perform some operations using Helm, all in Namespace mercury:
1. Delete release internal-issue-report-apiv1
2. Upgrade release internal-issue-report-apiv2 to any newer version of chart bitnami/nginx available
3. Install a new release internal-issue-report-apache of chart bitnami/apache. The Deployment should have two replicas, set these via Helm-values during install
4. There seems to be a broken release, stuck in pending-install state. Find it and delete it
</summary>
<p>
  
```bash
helm -n mercury uninstall internal-issue-report-apiv1
helm repo list; helm repo update; helm search repo nginx; helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
helm show values bitnami/apache | yq e; helm -n mercury install internal-issue-report-apache bitnami/apache --set replicaCount=2; k -n mercury get deploy internal-issue-report-apache
helm -n mercury uninstall internal-issue-report-daniel
```
</p>
</details>

### Q5 | ServiceAccount, Secret ###
<details><summary>
Team Neptune has its own ServiceAccount named neptune-sa-v2 in Namespace neptune. A coworker needs the token from the Secret that belongs to that ServiceAccount. Write the base64 decoded token to file /opt/course/5/token.
</summary>
<p>
  
```bash
k -n neptune get sa neptune-sa-v2 -o yaml | grep secret -A 2
k -n neptune get secret neptune-sa-v2-token-lwhhl -o yaml | base64 -d
OR
k -n neptune describe secret neptune-sa-v2-token-lwhhl
vim /opt/course/5/token #copy part under "token:" here from step above 
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
#(optional) view what docker container is doing
docker container run --rm docker/whalesay cowsay I am going to ace CKAD!
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

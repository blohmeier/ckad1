<details><summary>Exam link</summary>
https://kodekloud.com/topic/lightning-lab-2-2/
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
We have deployed a few pods in this cluster in various namespaces. Inspect them and identify the pod which is not in a Ready state. Troubleshoot and fix the issue.
Next, add a check to restart the container on the same pod if the command ls /var/www/html/file_check fails. This check should start after a delay of 10 seconds and run every 60 seconds.
</summary>
<p>
  
```bash
k get pods -A
k get pod -n dev1401 nginx1401 > 1.yml
vim 1.yml
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: nginx
  name: nginx1401
  namespace: dev1401
spec:
  containers:
  - image: kodekloud/nginx
    imagePullPolicy: IfNotPresent
    name: nginx
    ports:
    - containerPort: 9080
      protocol: TCP
    readinessProbe:
      httpGet:
        path: /
        port: 9080    
    livenessProbe:
      exec:
        command:
        - ls
        - /var/www/html/file_check
      initialDelaySeconds: 10
      periodSeconds: 60
k delete pod -n dev1401 nginx1401 $fg
k create -f 1.yml
```
</p>
</details>

### Check 2 ###
<details><summary>
Create a cronjob called dice that runs every one minute. Use the Pod template located at /root/throw-a-dice. The image throw-dice randomly returns a value between 1 and 6. The result of 6 is considered success and all others are failure.
The job should be non-parallel and complete the task once. Use a backoffLimit of 25. 
If the task is not completed within 20 seconds the job should fail and pods should be terminated.
</summary>
<p>
  
```bash
vim 2.yml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: dice
spec:
  schedule: "*/1 * * * *"
  jobTemplate:
    spec:
      completions: 1
      backoffLimit: 25 # This is so the job does not quit before it succeeds.
      activeDeadlineSeconds: 20
      template:
        spec:
          containers:
          - name: dice
            image: kodekloud/throw-dice
          restartPolicy: Never
k create -f 2.yml
```
</p>
</details>

### Check 3 ###
<details><summary>
Create a pod called my-busybox in the dev2406 namespace using the busybox image. The container should be called secret and should sleep for 3600 seconds. 
The container should mount a read-only secret volume called secret-volume at the path /etc/secret-volume. The secret being mounted has already been created for you and is called dotfile-secret.
Make sure that the pod is scheduled on controlplane and no other node in the cluster.
</summary>
<p>
  
```bash
vim 3.yml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: my-busybox
  name: my-busybox
  namespace: dev2406
spec:
  volumes:
  - name: secret-volume
    secret:
      secretName: dotfile-secret
  nodeSelector:
    kubernetes.io/hostname: controlplane
  tolerations:
  - key: "node-role.kubernetes.io/master"
    operator: "Exists"
    effect: "NoSchedule"
  containers:
  - command:
    - sleep
    args:
    - "3600"
    image: busybox
    name: secret
    volumeMounts:
    - name: secret-volume
      readOnly: true
      mountPath: "/etc/secret-volume"
k create -f 2.yml
```
</p>
</details>

### Check 4 ###
<details><summary>
Create a single ingress resource called ingress-vh-routing. The resource should route HTTP traffic to multiple hostnames as specified below:
The service video-service should be accessible on http://watch.ecom-store.com:30093/video.
The service apparels-service should be accessible on http://apparels.ecom-store.com:30093/wear.
Here 30093 is the port used by the Ingress Controller.
</summary>
<p>
  
```bash
vim 4.yml
kind: Ingress
apiVersion: networking.k8s.io/v1
metadata:
  name: ingress-vh-routing
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: watch.ecom-store.com
    http:
      paths:
      - pathType: Prefix
        path: "/video"
        backend:
          service:
            name: video-service
            port:
              number: 8080
  - host: apparels.ecom-store.com
    http:
      paths:
      - pathType: Prefix
        path: "/wear"
        backend:
          service:
            name: apparels-service
            port:
              number: 8080
k create -f 4.yml
```
</p>
</details>

### Check 5 ###
<details><summary>
A pod called dev-pod-dind-878516 has been deployed in the default namespace. Inspect the logs for the container called log-x and redirect the warnings to /opt/dind-878516_logs.txt on the controlplane node.
</summary>
<p>
  
```bash
k logs dev-pod-dind-878516 -c log-x | grep WARNING > /opt/dind-878516_logs.txt
```
</p>
</details>

## Study Path: ##
<details><summary></summary>
https://cloudacademy.com/learning-paths/certified-kubernetes-application-developer-ckad-exam-preparation-1-3086/?fromTp=true
</p></details>

# Exam 3: Multi-Container Pods #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab/ckad-practice-exam-multi-container-pods/?context_resource=lp&context_id=3086
</p></details>

<details><summary>Env Config:</summary>
<p>
  
```bash
export dy='--dry-run=client -o yaml' fg='--force --grace-period 0' && \
alias k=kubectl && source <(kubectl completion bash | sed 's/kubectl/k/g') && \
echo -e 'set nu et sts=2 sw=2 ts=2' >> ~/.vimrc
```
 
</p>
</details>

### Check 1:Pod with Legacy Logs ###
<details><summary>
A Pod in the mcp namespace has a single container named random that writes its logs to the /var/log/random.log file. Add a second container named second that uses the busybox image to allow the following command to display the logs written to the random container's /var/log/random.log file: </br>
  kubectl -n mcp logs random second
</summary>
<p>
  
```bash
k -n mcp get pod random -o yaml > 1_orig.yml
cp 1_orig.yml 1.yml
vim 1.yml:
apiVersion: v1
kind: Pod
metadata:
  name: random
  namespace: mcp
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - while true; do shuf -i 0-1 -n 1 >> /var/log/random.log; sleep 1; done
    image: busybox
    name: random
    volumeMounts:
    - mountPath: /var/log
      name: logs
  - name: second
    image: busybox
    args: [/bin/sh, -c, 'tail -n+1 -f /var/log/random.log']
    volumeMounts:
    - name: logs
      mountPath: /var/log
  volumes:
  - name: logs
```
  
</p>
</details>

### Check 2: Multi Container Pod Networking ###
The following multi-container Pod manifest needs to be updated BEFORE being deployed. Container c2 is designed to make HTTP requests to container c1. Before deploying this manifest, update it by substituting the <REPLACE_HOST_HERE> placeholder with the correct host or IP address - the remaining parts of the manifest must remain unchanged. Once deployed - confirm that the solution works correctly by executing the command kubectl logs -n app1 webpod -c c2 > /home/ubuntu/webpod-log.txt. The resulting /home/ubuntu/webpod-log.txt file should contain a single string within it.

```bash
apiVersion: v1
kind: Pod
metadata:
 name: webpod
 namespace: app1
spec:
 restartPolicy: Never
 volumes:
 - name: vol1
   emptyDir: {}
 containers:
 - name: c1
   image: nginx
   volumeMounts:
   - name: vol1
     mountPath: /usr/share/nginx/html
   lifecycle:
     postStart:
       exec:
         command:
           - "bash"
           - "-c"
           - |
             date | sha256sum | tr -d " *-" > /usr/share/nginx/html/index.html
 - name: c2
   image: appropriate/curl
   command: ["/bin/sh", "-c", "curl -s http://localhost && sleep 3600"]
```

<details><summary>show</summary><p>

```bash
k create -f <name for file created from manifest above>.yml
k logs -n app1 webpod -c c2 > /home/ubuntu/webpod-log.txt
  
```
</p>
</details>

### Check 3: Add New Container with ReadOnly Volume ###
Update and deploy the provided /home/ubuntu/md5er-app.yaml manifest file, adding a second container named c2 to the existing md5er Pod. The c2 container will run the same bash image that the c1 container already uses. The c2 container must mount the existing vol1 volume in read only mode, and such that it can execute the following bash script:

```bash
 for word in $(</data/file.txt)
 do 
 echo $word | md5sum | awk '{print $1}'
 done
```

<p>Note: The above command will simply generate an MD5 hash for each individual word found within the /data/file.txt file (generated by the c1 container).</p>

<p>Once deployed, run the following command to save the stdout output of the c2 container:</p>

```bash
kubectl logs -n app2 md5er c2 > /home/ubuntu/md5er-output.log
```

<details><summary>show</summary>
<p>
  
```bash
cp /home/ubuntu/md5er-app.yaml /home/ubuntu/md5er-app-original.yaml
vim /home/ubuntu/md5er-app.yaml:
apiVersion: v1
kind: Pod 
metadata:
 name: md5er
 namespace: app2
spec:
 restartPolicy: Never
 volumes:
 - name: vol1
   emptyDir: {}
 containers:
 - name: c1
   image: bash
   env:
   - name: DATA
     valueFrom:
      configMapKeyRef:
       name: cm1 
       key: data
   volumeMounts:
   - name: vol1
     mountPath: /data
   command: ["/usr/local/bin/bash", "-c", "echo $DATA > /data/file.txt"] ## Add from line below to end
 - name: c2										
   image: bash
   volumeMounts:
   - name: vol1
     mountPath: /data
     readOnly: true
   command:
     - "/usr/local/bin/bash"
     - "-c"										
     - | 										
       for word in $(</data/file.txt)			
       do										

k apply -f /home/ubuntu/md5er-app.yaml
k logs -n app2 md5er c2 > /home/ubuntu/md5er-output.log
  
```
</p>
</details>















#TEMPLATE
<details><summary>show</summary>
<p>
  
```bash

```
</p>
</details>
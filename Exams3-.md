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
vim 2.yml
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
# Create from file
k create -f 2.yaml
#Output to logs
kubectl logs -n app1 webpod -c c2 > /home/ubuntu/webpod-log.txt
```

<details><summary>show</summary>
<p>
  
```bash

```
</p>
</details>

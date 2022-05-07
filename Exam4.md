# Exam 4: Observability #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab/ckad-practice-exam-observability/?context_resource=lp&context_id=3086
</p></details>

### Check 1: Create Nginx Pod with Liveness HTTP Get Probe ###
<details><summary>
Create a new Pod named nginx in the ca1 namespace using the nginx image. Ensure that the pod listens on port 80 and configure it with a Liveness HTTP GET probe with the following configuration:
<ul><li>Probe Type: httpGet</li>
<li>Path: /</li>
<li>Port: 80</li>
<li>Initial delay seconds: 10</li>
  <li>Polling period seconds: 5</li></ul>
</summary>
<p>
  
```bash
k run nginx -n ca1 --image=nginx --restart=Never --port=80 $dy > 1.yml
vim 1.yml
apiVersion: v1
kind: Pod 
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
  namespace: ca1 
spec:
  containers:
  - image: nginx
    name: nginx
    ports:
    - containerPort: 80
    resources: {}
    livenessProbe:		#add from here to 'end'
      httpGet:
        path: /
        port: 80
      initialDelaySeconds: 10
      periodSeconds: 5

k create -f 1.yml
```
  
</p>
</details>

### Check 2: Hosting Service Not Working ###
A Service in the hosting Namespace is not responding to requests. Determine which Service is not working and resolve the underlying issue so the Service begins responding to requests.

<details><summary>show</summary><p>

```bash
k get svc -n hosting -o wide #List all svc in -n
k -n hosting get ep #Any svc associated with any Pod eps? web2 has none (can's serve requests).
k -n hosting get pods -l app=web2 #Two pods match web2 using "--selector" (-l) so no label issue. NOTE: are part of deploy. But not "READY"?
k -n hosting describe pods -l app=web2 #Both pods "Readiness probe failed...". Containers.Readiness: port 30, but "Port: 80/TCP" a few lines above. ort 80:
k edit deploy -n hosting web2 #Change Containers.Readiness: port 80
  
```
</p>
</details>

### Check 3: Pod Log Analysis ###
The ca2 namespace contains a set of pods. Pods labelled with app=test, or app=prod have been designed to log out a static list of numbers. Run a command that combines the pod logs for all pods that have the label app=prod and then get a total row count for the combined logs and save this result out to the file /home/ubuntu/combined-row-count-prod.txt.

<details><summary>show</summary>
<p>
  
```bash
k logs -n ca2 -l app=prod | wc -l > /home/ubuntu/combined-row-count-prod.txt
```
</p>
</details>

### Check 4: Pod Diagnostics ###
A pod named skynet has been deployed into the ca2 namespace. This pod has the following file /skynet/t2-specs.txt located within it, containing important information. You need to extract this file and save it to the following location /home/ubuntu/t2-specs.txt.

<details><summary>show</summary>
<p>
  
```bash
k exec -n ca2 skynet -- cat /skynet/t2-specs.txt > /home/ubuntu/t2-specs.txt
```
</p>
</details>

### Check 5: Pod CPU Utilization ###
Find the Pod that has the highest CPU utilization in the matrix namespace. Write the name of this pod into the following file: /home/ubuntu/max-cpu-podname.txt

<details><summary>show</summary>
<p>
  
```bash
k top pods -n matrix --sort-by=cpu --no-headers=true | head -n1 | cut -d" " -f1 > /home/ubuntu/max-cpu-podname.txt
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

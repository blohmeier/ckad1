# Exam 5: Pod Design #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab/ckad-practice-exam-pod-design/?context_resource=lp&context_id=3086
</p></details>

### Check 1: Create and Manage Deployments ###
<details><summary>
Create a deployment named webapp in the zap namespace. Use the nginx:1.17.8 image and set the number of replicas initially to 2. Next, scale the current deployment up from 2 to 4. Finally, update the deployment to use the newer nginx:1.19.0 image.
</summary>
<p>
  
```bash
k create deploy -n zap webapp --image=nginx:1.17.8 --replicas=2
k scale deploy -n zap webapp --replicas=4
k edit deploy -n zap webapp #edit "image" field
```
  
</p>
</details>

### Check 2: Create Pod Labels ###
Add an additional label app=cloudacademy to all pods currently running in the gzz namespace that have the label env=prod

<details><summary>show</summary><p>

```bash
k get pod -n gzz -l env=prod
k label pod -n gzz -l env=prod app=cloudacademy
  
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

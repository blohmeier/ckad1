<details><summary>Exam link</summary>
https://kodekloud.com/topic/mock-exam-1-5/
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
Deploy a pod named nginx-448839 using the nginx:alpine image.
</summary>
<p>
  
```bash
k run nginx-448839 --image=nginx:alpine
```
</p>
</details>

### Check 2 ###
<details><summary>
Create a namespace named apx-z993845.
</summary>
<p>
  
```bash
k create ns apx-z993845
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

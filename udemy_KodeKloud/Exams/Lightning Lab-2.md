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
k describe pod -n dev1401 nginx1401
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

```
</p>
</details>

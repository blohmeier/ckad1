# K8s Certification Challenge (final exam 1 of 3) #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab-challenge/certified-kubernetes-application-developer-ckad-challenge/?context_resource=lp&context_id=3086
</p></details>

<details><summary>
environment Set up
</summary>
<p>
  
```bash
export dy='--dry-run=client -o yaml' fg='--force --grace-period 0' && \
alias k=kubectl && source <(kubectl completion bash | sed 's/kubectl/k/g') && \
echo "source <(kubectl completion bash)" >> $HOME/.bashrc && \
echo -e 'set nu ts=2 sw=2 sts=2 et' >> ~/.vimrc

tmux; ctrl-b; %

```
</p>
</details>

### Check 1: Check 1: Service Account ###
<details><summary>
Create a service account named inspector in the dwx7eq namespace. Then create a deployment named calins in the same namespace. Use the image busybox:1.31.1 for the only pod container and pass the arguments sleep and 24h to the container. Set the number of replicas to 1. Lastly, make sure that the deployments' pod is using the inspector service account.
</summary>
<p>
  
```bash

```
</p>
</details>

### Check 2: Evictions ###
<details><summary>
The mission-critical deployment in the bk0c2d namespace has been getting evicted when the Kubernetes cluster is consuming a lot of memory. Modify the deployment so that it will not be evicted when the cluster is under memory pressure unless there are higher priority pods running in the cluster (Guaranteed Quality of Service). It is known that the container for the deployment's pod requires and will not use more than 200 milliCPU (200m) and 200 mebibytes (200Mi) of memory.
</summary>
<p>

```bash

```
</p>
</details>
  

### Check 3: Persisting Data ###
<details><summary>
A legacy application runs via a deployment in the zuc0co namespace. The deployment's pod uses a multi-container pod to convert the legacy application's raw metric output into a format that can be consumed by a metric aggregation system. However, the data is currently lost every time the pod is deleted. Modify the deployment to use a persistent volume claim with 2GiB of storage and access mode of ReadWriteOnce so the data is persisted if the pod is deleted.
</summary>
<p>
  
```bash

```
</p>
</details>

### Check 4: Multi-Container Pattern ###
<details><summary>
Write the name of the multi-container pod design pattern used by the pod in the previous task to a file at /home/ubuntu/mcpod.
</summary>
<p>
  
```bash

```
</p>
</details>

### TEMPLATE ###
<details><summary>
</summary>
<p>
  
```bash

```
</p>
</details>

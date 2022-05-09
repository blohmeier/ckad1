<details><summary>Exam link</summary>
https://kodekloud.com/topic/lightning-lab-1-4/
</p></details>

### Check 1 ###
<details><summary>
Create a Persistent Volume called log-volume. It should make use of a storage class name manual. It should use RWX as the access mode and have a size of 1Gi. The volume should use the hostPath /opt/volume/nginx
Next, create a PVC called log-claim requesting a minimum of 200Mi of storage. This PVC should bind to log-volume.
Mount this in a pod called logger at the location /var/www/nginx. This pod should use the image nginx:alpine.
</summary>
<p>
  
```bash
vim 1_pv.yml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: log-volume
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  storageClassName: manual
  hostPath:
    path: "opt/volume/nginx"

k create -f 1_pv.yml
vim 1_pvc.yml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: log-claim
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 200Mi

k create -f 1_pvc.yml
k run logger --image=nginx:alpine $dy > 1_pod.yml
vim 1_pod.yml

apiVersion: v1
kind: Pod
metadata:
  name: logger
spec:
  containers:
    - name: logger
      image: nginx:alpine
      volumeMounts:
        - name: config
          mountPath: /var/www/nginx
  volumes:
    - name: config
      persistentVolumeClaim:
        claimName: log-clai
```
  
</p>
</details>

### Check 2 ###
We have deployed a new pod called secure-pod and a service called secure-service. Incoming or Outgoing connections to this pod are not working. 
Troubleshoot why this is happening.
Make sure that incoming connection from the pod webapp-color are successful.

<details><summary>show</summary><p>

```bash
k get svc
k exec -it webapp-color -- sh
nc -zvw 1 secure-service 80
k get netpol default-deny -o yaml > 2_netpol.yml
vim 2_netpol.yml #Final config follows

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-webapp-color
spec:
  podSelector:
    matchLabels:
      role: db
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector:
            matchLabels:
              name: webapp-color
      ports:
        - protocol: TCP 
          port: 80

k create -f 2_netpol.yml

k exec -it webapp-color -- sh
nc -z -v -w 1 secure-service 80  
```
</p>
</details>

### Check 3: Rollback Deployment ###
The nginx container running within the cloudforce deployment in the fre namespace needs to be updated to use the nginx:1.19.0-perl image. Perform this deployment update and ensure that the command used to perform it is recorded in the tracked rollout history.

<details><summary>show</summary>
<p>
  
```bash
k -n fre set image deployment cloudforce nginx=nginx:1.19.0-perl --record
```
</p>
</details>

### Check 4: Configure Pod AutoScaling ###
A deployment named eclipse has been created in the xx1 namespace. This deployment currently consists of 2 replicas. Configure this deployment to autoscale based on CPU utilisation. The autoscaling should be set for a minimum of 2, maximum of 4, and CPU usage of 65%.

<details><summary>show</summary>
<p>
  
```bash
k -n xx1 autoscale deploy --min=2 --max=4 --cpu-percent=65 eclipse
```
</p>
</details>

### Check 5: Create CronJob ###
<p>Create a cronjob named matrix in the saas namespace. Use the radial/busyboxplus:curl image and set the schedule to */10 * * * *. </p>
<p>The job should run the command: curl www.google.com</p>
<details><summary>show</summary>
<p>
  
```bash
k -n saas create cronjob --image=radial/busyboxplus:curl --schedule='*/10 * * * *' matrix -- curl www.google.com
```
</p>
</details>

### Check 6: Filter and Sort Pods ###
<p>Get a list of all pod names running in the rep namespace which have their colour label set to either orange, red, or yellow. The returned pod name list should contain only the pod names and nothing else. The pods names should be ordered by the cluster IP address assigned to each pod. The resulting pod name list should be saved out to the file /home/ubuntu/pod001 </p>
<p>The following list is an example of the required output:</p>
pod6</br>
pod17</br>
pod3</br>
pod16</br>
pod15</br>
pod13</br></br>

<details><summary>show</summary>
<p>
  
```bash
k -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' > /home/ubuntu/pod001
EQUIVALENT LINUX COMMANDS:
# cut the first column of the earlier table output and remove the column heading
kubectl -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP | cut -d' ' -f1 | tail +2
# grep the pod name and only output the matching characters
kubectl -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP | grep -o -e "pod[0-9]*"
DETAILED STEPS FOR FIRST ANSWER ABOVE
  kubectl -n rep get pods --selector 'colour in (orange,red,yellow)' --show-labels #Confirm only desired pods are selected
  kubectl -n rep get pod pod1 -o yaml; kubectl explain pod; kubectl explain pod.status #Determine JSONPATH expression for PodIP (.status.podIP)
  kubectl -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP -o wide #Output IP addresses to confirm step above
  kubectl -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP -o jsonpath='{.items[*].metadata.name}' #Task only requires pod names
  kubectl -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' #Range function to output in column format
  kubectl -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP -o custom-columns="NAME:.metadata.name" #Alternative to step above
  
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


# Exam 6: Services And Networking #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab/ckad-practice-exam-services-networking/?context_resource=lp&context_id=3086
</p></details>

### Check 1: Create and Configure a Basic Pod ###
<details><summary>
Create a Pod in the red Namespace with the following configuration:
<ul><li>The Pod is named basic</li>
<li>The Pod uses the nginx:stable-alpine-perl image for its only container</li>
<li>Restart the Pod only OnFailure</li>
<li>Ensure port 80 is open to TCP traffic</li></ul></summary>
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
<p>pod6</p>
<p>pod17</p>
<p>pod3</p>
<p>pod16</p>
<p>pod15</p>
<p>pod13</p>

<details><summary>show</summary>
<p>
  
```bash
k -n rep get pods --selector 'colour in (orange,red,yellow)' --sort-by=.status.podIP -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}' > /home/ubuntu/pod001

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

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
k run -n red basic --image=nginx:stable-alpine-perl --restart=OnFailure --port=80
```

</p>
</details>

### Check 2: Expose Pod ###
<details><summary>
Expose the Pod named basic in the red Namespace, ensuring it has the following settings:
<ul><li>Service name is cloudacademy-svc</li>
<li>Service port is 8080</li>
<li>Target port is 80</li>
<li>Service type is ClusterIP</li></ul></summary>
<p>
  
```bash

```

</p>
</details>

### Check 3: Expose Existing Deployment ###
<details><summary>
A Deployment named cloudforce has been created in the ca1 Namespace. You must now expose this Deployment as a NodePort based Service using the following settings:
<ul><li>Service name is cloudacademy-svc</li>
<li>Service type is ClusterIP</li>
<li>Service port is 80</li>
<li>NodePort is 32080</li></ul></summary>
<p>
  
```bash

```

</p>
</details>

### Check 4: Fix Networking Issue ###
A Deployment named t2 has been created in the skynet Namespace, and has been exposed as a ClusterIP based Service named t2-svc. The t2-svc Service when contacted should return a valid HTTP response, but unfortunately, this is currently not yet the case. Please investigate and fix the problem. When you have applied the fix, run the following command to save the HTTP response:
```bash
kubectl run client -n skynet --image=appropriate/curl -it --rm --restart=Never -- curl http://t2-svc:8080 > /home/ubuntu/svc-output.txt
```

<details><summary>show</summary>
<p>
  
```bash

```
</p>
</details>

### Check 5: Create CronJob ###
<details><summary>
The following two Pods have been created in the sec1 Namespace:
<ul><li>pod1 has the label app=test</li>
<li>pod2 has the label app=client</li></ul>
<p>A NetworkPolicy named netpol1 has also been established in the sec1 Namespace but is currently blocking traffic sent from pod2 to pod1. Update the NetworkPolicy to ensure that pod2 can send traffic to pod1.</p></summary>
<p>
  
```bash
  
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

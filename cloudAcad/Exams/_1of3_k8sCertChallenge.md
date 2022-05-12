# K8s Certification Challenge (final exam 1 of 3) #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab-challenge/kubernetes-certification-challenge/?context_resource=lp&context_id=3086
</p></details>

### Check 1: Created Specified Deployment ###
<details><summary>
Create a deployment named chk1 in the cal namespace. Use the image nginx:1.15.12-alpine and set the number of replicas to 3. Finally, ensure the revision history limit is set to 50.
</summary>
<p>
  
```bash

```

</p>
</details>

### Check 2: Resolve Configuration Issues ###
<details><summary>
The site deployment in the pwn namespace is supposed to be exposed to clients outside of the Kubernetes cluster by the sitelb service. However, requests sent to the service do not reach the deployment's pods. Resolve the service configuration issue so the requests sent to the service do reach the deployment's pods.

```bash
apiVersion: v1
kind: Pod
metadata:
  labels:
    env: prod
  name: logger
  namespace: blah
spec:
  containers:
  - image: bash
    name: c1
    command: ["/usr/local/bin/bash", "-c"]
    args:
    - ifconfig > /var/log/blah/data;
      sleep 3600;
  - image: bash
    name: c2
    command: ["/usr/local/bin/bash", "-c"]
    args:
    - sleep 3600;
```

</summary>
<p>
  
```bash

```

</p>
</details>


#TEMPLATE
<details><summary>show</summary>
<p>
  
```bash
cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
 labels:
   env: prod
 name: logger
 namespace: blah
spec:
 containers:
 - image: bash
   name: c1
   command: ["/usr/local/bin/bash", "-c"]
   args:
    - ifconfig > /var/log/blah/data;
      sleep 3600;
   volumeMounts:
   - mountPath: /var/log/blah
     name: vol1
 - image: bash
   name: c2
   command: ["/usr/local/bin/bash", "-c"]
   args:
    - sleep 3600;
   volumeMounts:
   - mountPath: /var/log/blah
     name: vol1
 volumes:
 - name: vol1
   hostPath:
     path: /tmp/vol
EOF
```
</p>
</details>

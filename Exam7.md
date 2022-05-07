# Exam 7: State Persistence #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab/ckad-practice-exam-state-persistence/connecting-practice-exam-kubernetes-cluster/?context_id=3086&context_resource=lp
</p></details>

### Check 1: Persisting Data ###
<details><summary>
Create a PersistentVolume named pv in the qq3 Namespace. The PersistentVolume must be configured with the following settings:
<ul><li>storageClassName: host</li>
<li>2Gi of storage capacity</li>
<li>Allow a single Node read-write access</li>
<li>Use a hostPath of /mnt/data</li></ul>
The PersistentVolume must be claimed by a PersistentVolumeClaim named pvc. The PersistentVolume must request 1Gi of storage capacity.
Lastly, create a Pod named persist with one redis container. The Pod must use the pvc PersistentVolumeClaim to mount a volume at /data.
</summary>
<p>
  
```bash

```

</p>
</details>

### Check 2: Volume Mounts ###
<details><summary>
The following manifest declares a single Pod named logger in the blah namespace. The logger Pod contains two containers c1 and c2. Before applying this manifest into the cluster, update it so that it declares a hostPath based Volume named vol1 with the host path set to /tmp/vol, and then mount this volume into both the c1 and c2 containers using the container directory /var/log/blah.

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

```
</p>
</details>

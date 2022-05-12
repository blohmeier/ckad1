# K8s Certification Challenge (final exam 1 of 3) #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab-challenge/kubernetes-certification-challenge/?context_resource=lp&context_id=3086
</p></details>

### Check 1: Persisting Data ###
<details><summary>
Create a PersistentVolume named pv in the qq3 Namespace. The PersistentVolume must be configured with the following settings:
<ul><li>storageClassName: host</li>
<li>2Gi of storage capacity</li>
<li>Allow a single Node read-write access</li>
<li>Use a hostPath of /mnt/data</li></ul>
<p>The PersistentVolume must be claimed by a PersistentVolumeClaim named pvc. The PersistentVolume must request 1Gi of storage capacity.</p>
<p>Lastly, create a Pod named persist with one redis container. The Pod must use the pvc PersistentVolumeClaim to mount a volume at /data.</p>
</summary>
<p>
  
```bash
# Create a PersistentVolume named pv in the qq3 Namespace. The PersistentVolume must be configured with the following settings: storageClassName: host, 2Gi of storage capacity, Allow a single Node read-write access, Use a hostPath of /mnt/data
cat << EOF | kubectl -n qq3 apply -f -
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv
spec:
  storageClassName: host
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: "/mnt/data"
EOF
# The PersistentVolume must be claimed by a PersistentVolumeClaim named pvc. The PersistentVolume must request 1Gi of storage capacity.
cat << EOF | kubectl -n qq3 apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc
spec:
  storageClassName: host
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
EOF
# Lastly, create a Pod named persist with one redis container. The Pod must use the pvc PersistentVolumeClaim to mount a volume at /data.
cat << EOF | kubectl -n qq3 apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: persist
spec:
  volumes:
    - name: data
      persistentVolumeClaim:
        claimName: pvc
  containers:
    - name: persist
      image: redis
      volumeMounts:
        - mountPath: "/data"
          name: data
EOF
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

1
<details><summary>

</summary>
<p>

```bash
CORRECT:
vim 1_deploy.yml:
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    tier: frontend
    app: my-webapp
  name: my-webapp
spec:
  replicas: 2
  selector:
    matchLabels:
      app: my-webapp
  template:
    metadata:
      labels:
        app: my-webapp
    spec:
      containers:
      - image: nginx
        name: nginx
k create -f 1_deploy.yml
k expose deploy my-webapp --name front-end-service --type NodePort --port 80 $dy > 1_svc.yml
vim 1_svc.yml 
#at spec.template.spec.ports, add "nodePort" field:
 - port: 80
   protocol: TCP
   targetPort: 80
   nodePort: 30083
k create -f 1_svc.yml

MINE:
```
</p>
</details>

4
<details><summary>

</summary>
<p>

```bash
CORRECT:
k create ingress ingress --rule="ckad-mock-exam-solution.com/video*=my-video-service:8080" $dy > 4.yml
k create -f 4.yml
MINE:
```
</p>
</details>

5
<details><summary>

</summary>
<p>

```bash
CORRECT:
MINE:
```
</p>
</details>

6
<details><summary>

</summary>
<p>

```bash
CORRECT:
apiVersion: v1
kind: Pod
metadata:
  name: nginx1401
  namespace: default
spec:
  containers:
    - name: nginx1401
      image: nginx
      livenessProbe:
        exec:
          command: ["ls /var/www/html/probe"]
        initialDelaySeconds: 10
        periodSeconds: 60
MINE:
```
</p>
</details>

8
<details><summary>

</summary>
<p>

```bash
CORRECT:
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: multi-pod
  name: multi-pod
spec:
  containers:
  - image: nginx
    name: jupiter
    env:
    - name: type
      value: planet
  - image: busybox
    name: europa
    command: ["/bin/sh","-c","sleep 4800"]
    env:
     - name: type
       value: moon
MINE:
```
</p>
</details>

9
<details><summary>

</summary>
<p>

```bash
CORRECT:
kind: PersistentVolume
apiVersion: v1
metadata:
  name: custom-volume
spec:
  accessModes: ["ReadWriteMany"]
  capacity:
    storage: 50Mi
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /opt/data

MINE:
apiVersion: v1
kind: PersistentVolume
metadata:
  name: custom-volume
  labels:
    type: local
spec:
  capacity:
    storage: 50MiB
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/opt/data"
```
</p>
</details>

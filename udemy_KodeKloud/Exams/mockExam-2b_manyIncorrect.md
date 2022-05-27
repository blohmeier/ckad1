1
<details><summary>
Create a deployment called my-webapp with image: nginx, label tier:frontend and 2 replicas. Expose the deployment as a NodePort service with name front-end-service , port: 80 and NodePort: 30083
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
Create a new Ingress Resource for the service: my-video-service to be made available at the URL: http://ckad-mock-exam-solution.com:30093/video.
Create an ingress resource with host: ckad-mock-exam-solution.com
path: /video
Once set up, curl test of the URL from the nodes should be successful / HTTP 200
  <ul><li> http://ckad-mock-exam-solution.com:30093/video accessible? </li></ul>
</summary>
<p>

```bash
CORRECT:
k create ingress ingress --rule="ckad-mock-exam-solution.com/video*=my-video-service:8080" $dy > 4.yml
k create -f 4.yml
MINE:
root@controlplane ~ ➜  curl http://ckad-mock-exam-solution.com:30093/video
<!doctype html>
<title>Hello from Flask</title>
<body style="background: #30336b;">

<div style="color: #e4e4e4;
    text-align:  center;
    height: 90px;
    vertical-align:  middle;">
    <img src="https://res.cloudinary.com/cloudusthad/image/upload/v1547053817/error_404.png">

</div>

</body>
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
Create a new pod called nginx1401 in the default namespace with the image nginx. Add a livenessProbe to the container to restart it if the command ls /var/www/html/probe fails. This check should start after a delay of 10 seconds and run every 60 seconds.
You may delete and recreate the object. Ignore the warnings from the probe.
Pod created correctly with the livenessProbe?
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
Create a pod called multi-pod with two containers. 
Container 1: 
name: jupiter, image: nginx
Container 2: 
name: europa, image: busybox
command: sleep 4800
Environment Variables: 
Container 1: 
type: planet
Container 2: 
type: moon
Pod Name: multi-pod
Container 1: jupiter
Container 2: europa
Container europa commands set correctly?
Container 1 Environment Value Set
Container 2 Environment Value Set
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
Create a PersistentVolume called custom-volume with size: 50MiB reclaim policy:retain, Access Modes: ReadWriteMany and hostPath: /opt/data
PV custom-volume created?
custom-volume uses the correct access mode?
PV custom-volume has the correct storage capacity?
PV custom-volume has the correct host path?
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

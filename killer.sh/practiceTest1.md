<details><summary>Exam link</summary>
https://killer.sh/dashboard
</p></details>

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

### Q1 | Namespaces ###
<details><summary>
The DevOps team would like to get the list of all Namespaces in the cluster. Get the list and save it to /opt/course/1/namespaces.
</summary>
<p>
  
```bash
k get ns > /opt/course/1/namespaces
  
```
</p>
</details>

### Q2 | Pods ###
<details><summary>
Create a single Pod of image httpd:2.4.41-alpine in Namespace default. The Pod should be named pod1 and the container should be named pod1-container.
Your manager would like to run a command manually on occasion to output the status of that exact Pod. Please write a command that does this into /opt/course/2/pod1-status-command.sh. The command should use kubectl.
</summary>
<p>
  
```bash
k run pod1 --image=httpd:2.4.41-alpine $dy > 2.yaml
vim 2.yaml
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: pod1
  name: pod1
spec:
  containers:
  - image: httpd:2.4.41-alpine
    name: pod1-container # change
k create -f 2.yml
k get pod pod1 -o jsonpath="{.status.phase}" > /opt/course/2/pod1-status-command.sh
```
</p>
</details>

### Q3 | Job ###
<details><summary>
Team Neptune needs a Job template located at /opt/course/3/job.yaml. This Job should run image busybox:1.31.0 and execute sleep 2 && echo done. It should be in namespace neptune, run a total of 3 times and should execute 2 runs in parallel.
Start the Job and check its history. Each pod created by the Job should have the label id: awesome-job. The job should be named neb-new-job and the container neb-new-job-container.
</summary>
<p>
  
```bash
k -n neptune create job neb-new-job --image=busybox:1.31.0 $dy > /opt/course/3/job.yaml -- sh -c "sleep 2 && echo done"
vim /opt/course/3/job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  creationTimestamp: null
  name: neb-new-job
  namespace: neptune      # add
spec:
  completions: 3          # add
  parallelism: 2          # add
  template:
    metadata:
      creationTimestamp: null
      labels:             # add
        id: awesome-job   # add
    spec:
      containers:
      - command:
        - sh
        - -c
        - sleep 2 && echo done
        image: busybox:1.31.0
        name: neb-new-job-container # update
k create -f /opt/course/3/job.yaml
```
</p>
</details>

### Q4 | Helm Management ###
<details><summary>
Team Mercury asked you to perform some operations using Helm, all in Namespace mercury:
1. Delete release internal-issue-report-apiv1
2. Upgrade release internal-issue-report-apiv2 to any newer version of chart bitnami/nginx available
3. Install a new release internal-issue-report-apache of chart bitnami/apache. The Deployment should have two replicas, set these via Helm-values during install
4. There seems to be a broken release, stuck in pending-install state. Find it and delete it
</summary>
<p>
  
```bash
helm -n mercury uninstall internal-issue-report-apiv1
helm repo list; helm repo update; helm search repo nginx; helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
helm show values bitnami/apache | yq e; helm -n mercury install internal-issue-report-apache bitnami/apache --set replicaCount=2; k -n mercury get deploy internal-issue-report-apache
helm -n mercury uninstall internal-issue-report-daniel
```
</p>
</details>

### Q5 | ServiceAccount, Secret ###
<details><summary>
Team Neptune has its own ServiceAccount named neptune-sa-v2 in Namespace neptune. A coworker needs the token from the Secret that belongs to that ServiceAccount. Write the base64 decoded token to file /opt/course/5/token.
</summary>
<p>
  
```bash
k -n neptune get sa neptune-sa-v2 -o yaml | grep secret -A 2
k -n neptune get secret neptune-sa-v2-token-lwhhl -o yaml | base64 -d
OR
k -n neptune describe secret neptune-sa-v2-token-lwhhl
vim /opt/course/5/token #copy part under "token:" here from step above 
```
</p>
</details>

### Q6 | ReadinessProbe ###
<details><summary>
Create a single Pod named pod6 in Namespace default of image busybox:1.31.0. The Pod should have a readiness-probe executing cat /tmp/ready. It should initially wait 5 and periodically wait 10 seconds. This will set the container ready only if the file /tmp/ready exists.
The Pod should run the command touch /tmp/ready && sleep 1d, which will create the necessary file to be ready and then idles. Create the Pod and confirm it starts.
</summary>
<p>
  
```bash
k run pod6 --image=busybox:1.31.0 $dy --command -- sh -c "touch /tmp/ready && sleep 1d" > 6.yaml
vim 6.yml #add spec.containers.readinessProbe and add below that:
exec:                                     # add
  command:                                # add
  - sh                                    # add
  - -c                                    # add
  - cat /tmp/ready                        # add
 initialDelaySeconds: 5                   # add
 periodSeconds: 10                        # add
k create -f 6.yml
```
</p>
</details>

### Q7 | Pods, Namespaces ###
<details><summary>
<p>The board of Team Neptune decided to take over control of one e-commerce webserver from Team Saturn. The administrator who once setup this webserver is not part of the organisation any longer. All information you could get was that the e-commerce system is called my-happy-shop.</p>
<p>Search for the correct Pod in Namespace saturn and move it to Namespace neptune. It doesn't matter if you shut it down and spin it up again, it probably hasn't any customers anyways.</p>
</summary>
<p>
  
```bash
k -n saturn get pod -o yaml | grep my-happy-shop -A10
k -n saturn get pod webserver-sat-003 -o yaml > 7_webserver-sat-003.yaml
vim 7_webserver-sat-003.yaml #change ns, remove "status:" section, token vol & volMount, & nodeName
k create -f 7_webserver-sat-003.yaml
k -n saturn delete pod webserver-sat-003 $fg
```
</p>
</details>

### Q8 | Deployment, Rollouts ###
<details><summary>
There is an existing Deployment named api-new-c32 in Namespace neptune. A developer did make an update to the Deployment but the updated version never came online. Check the Deployment history and find a revision that works, then rollback to it. Could you tell Team Neptune what the error was so it doesn't happen again?
</summary>
<p>
  
```bash
k -n neptune rollout history deploy api-new-c32
k -n neptune get deploy,pod | grep api-new-c32
k -n neptune describe pod api-new-c32-7d64747c87-zh648 | grep -i error; k -n neptune describe pod api-new-c32-7d64747c87-zh648 | grep -i image
k -n neptune rollout undo deploy api-new-c32
```
</p>
</details>

### Q9 | Pod -> Deployment ###
<details><summary>
<p>In Namespace pluto there is single Pod named holy-api. It has been working okay for a while now but Team Pluto needs it to be more reliable. Convert the Pod into a Deployment with 3 replicas and name holy-api. The raw Pod template file is available at /opt/course/9/holy-api-pod.yaml.</p>
<p>In addition, the new Deployment should set allowPrivilegeEscalation: false and privileged: false for the security context on container level.</p>
<p>Please create the Deployment and save its yaml under /opt/course/9/holy-api-deployment.yaml.</p>
</summary>
<p>

add below from _`Deployment`_ example yaml.

```bash
cp /opt/course/9/holy-api-pod.yaml /opt/course/9/holy-api-deployment.yaml
vim /opt/course/9/holy-api-deployment.yaml #
apiVersion: apps/v1
kind: Deployment
metadata:
  name: holy-api        # name stays the same
  namespace: pluto      # important
spec:
  replicas: 3           # 3 replicas
  selector:
    matchLabels:
      id: holy-api      # set the correct selector
  template:
    # => from here down its the same as the pods metadata: and spec: sections
#add spec.template.spec.containers.securityContext and indented from that add:
  allowPrivilegeEscalation: false  # add
  privileged: false                # add

k -f create /opt/course/9/holy-api-deployment.yaml
k -n pluto delete pod holy-api $fg
```
</p>
</details>

add below from _`Deployment`_ example yaml.

### Q10 | Service, Logs ###
<details><summary>
<p>Team Pluto needs a new cluster internal Service. Create a ClusterIP Service named project-plt-6cc-svc in Namespace pluto. This Service should expose a single Pod named project-plt-6cc-api of image nginx:1.17.3-alpine, create that Pod as well. The Pod should be identified by label project: plt-6cc-api. The Service should use tcp port redirection of 3333:80.</p>

<p>Finally use for example curl from a temporary nginx:alpine Pod to get the response from the Service. Write the response into /opt/course/10/service_test.html. Also check if the logs of Pod project-plt-6cc-api show the request and write those into /opt/course/10/service_test.log.</p>
</summary>
<p>
  
```bash
k -n pluto run project-plt-6cc-api --image=nginx:1.17.3-alpine --labels project=plt-6cc-api
k -n pluto expose pod project-plt-6cc-api --name project-plt-6cc-svc --port 3333 --target-port 80
k run tmp --restart=Never --rm --image=nginx:alpine -i -- curl http://project-plt-6cc-svc.pluto:3333 > /opt/course/10/service_test.html #pipe results from confirming cnxn w/tmp pod
k -n pluto logs project-plt-6cc-api > /opt/course/10/service_test.log
```
</p>
</details>

### Q11 | Working with Containers ###
<details><summary>
During the last monthly meeting you mentioned your strong expertise in container technology. Now the Build&Release team of department Sun is in need of your insight knowledge. There are files to build a container image located at /opt/course/11/image. The container will run a Golang application which outputs information to stdout. You're asked to perform the following tasks:
<ol><li>Change the Dockerfile. The value of the environment variable SUN_CIPHER_ID should be set to the hardcoded value 5b9c1065-e39d-4a43-a04a-e59bcea3e03f</li>
<li>Build the image using Docker, named registry.killer.sh:5000/sun-cipher, tagged as latest and v1-docker, push these to the registry</li>
<li>Build the image using Podman, named registry.killer.sh:5000/sun-cipher, tagged as v1-podman, push it to the registry</li>
<li>Run a container using Podman, which keeps running in the background, named sun-cipher using image registry.killer.sh:5000/sun-cipher:v1-podman. Run the container from k8s@terminal and not root@terminal</li>
<li>Write the logs your container sun-cipher produced into /opt/course/11/logs. Then write a list of all running Podman containers into /opt/course/11/containers</li></ol>
</summary>
<p>
  
```bash
# change line per step 1. Next:
sudo docker build -t registry.killer.sh:5000/sun-cipher:latest -t registry.killer.sh:5000/sun-cipher:v1-docker .
sudo docker push registry.killer.sh:5000/sun-cipher:latest
sudo docker push registry.killer.sh:5000/sun-cipher:v1-docker
podman build -t registry.killer.sh:5000/sun-cipher:v1-podman .
podman push registry.killer.sh:5000/sun-cipher:v1-podman
su - k8s #only if not already k8s@terminal. Or can just 'exit' from root. To go back to root, sudo su w/no pw.
podman run -d --name sun-cipher registry.killer.sh:5000/sun-cipher:v1-podman
podman ps > /opt/course/11/containers
podman logs sun-cipher > /opt/course/11/logs
```
</p>
</details>

### Q12 | Storage, PV, PVC, Pod volume ###
<details><summary>
<p>Create a new PersistentVolume named earth-project-earthflower-pv. It should have a capacity of 2Gi, accessMode ReadWriteOnce, hostPath /Volumes/Data and no storageClassName defined.</p>
<p>Next create a new PersistentVolumeClaim in Namespace earth named earth-project-earthflower-pvc . It should request 2Gi storage, accessMode ReadWriteOnce and should not define a storageClassName. The PVC should bound to the PV correctly.</p>
<p>Finally create a new Deployment project-earthflower in Namespace earth which mounts that volume at /tmp/project-data. The Pods of that Deployment should be of image httpd:2.4.41-alpine.</p>
</summary>
<p>
  
```bash
#modify 12_pv.yml, 12_pvc.yml and 12_dep.yml from:
  https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolume (link within https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes)
  application/wordpress/mysql-deployment.yaml (at https://kubernetes.io/docs/tutorials/stateful-application/mysql-wordpress-persistent-volume/)
k create 12_pv.yml
k create 12_pvc.yml
k -n earth get pv,pvc #STATUS: Bound
k create 12_dep.yml
k -n earth describe pod project-earthflower-<deployID>-<podID> | grep -A2 Mounts:
```
</p>
</details>

### Q13 | Storage, StorageClass, PVC ###
<details><summary>
Team Moonpie, which has the Namespace moon, needs more storage. Create a new PersistentVolumeClaim named moon-pvc-126 in that namespace. This claim should use a new StorageClass moon-retain with the provisioner set to moon-retainer and the reclaimPolicy set to Retain. The claim should request storage of 3Gi, an accessMode of ReadWriteOnce and should use the new StorageClass.
The provisioner moon-retainer will be created by another team, so it's expected that the PVC will not boot yet. Confirm this by writing the log message from the PVC into file /opt/course/13/pvc-126-reason.
</summary>
<p>
  
```bash
#edit and "k create -f" for sc from template at https://kubernetes.io/docs/concepts/storage/storage-classes/
#edit and "k create -f" for pvc from template at https://kubernetes.io/docs/tasks/configure-pod-container/configure-persistent-volume-storage/#create-a-persistentvolume (link within https://kubernetes.io/docs/concepts/storage/persistent-volumes/#persistent-volumes)
k -n moon describe pvc moon-pvc-126 # and paste "Events:" text sentence into /opt/course/13/pvc-126-reason
```
</p>
</details>

### Q14 | Secret, Secret-Volume, Secret-Env ###
<details><summary>
You need to make changes on an existing Pod in Namespace moon called secret-handler. Create a new Secret secret1 which contains user=test and pass=pwd. The Secret's content should be available in Pod secret-handler as environment variables SECRET1_USER and SECRET1_PASS. The yaml for Pod secret-handler is available at /opt/course/14/secret-handler.yaml.
There is existing yaml for another Secret at /opt/course/14/secret2.yaml, create this Secret and mount it inside the same Pod at /tmp/secret2. Your changes should be saved under /opt/course/14/secret-handler-new.yaml. Both Secrets should only be available in Namespace moon.
</summary>
<p>
  
```bash
?
```
</p>
</details>

### Q14 | Secret, Secret-Volume, Secret-Env ###
<details><summary>
?
</summary>
<p>
  
```bash
?
```
</p>
</details>
  
cat << EOF | k create -f -
  

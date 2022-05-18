<details><summary>Exam links</summary>
https://killer.sh/dashboard
https://nigelpoulton.com/explained-kubernetes-service-ports/?force_isolation=true
</p></details>

<details><summary>vim config</summary>
<p>
  
```bash
export dy='--dry-run=client -o yaml' fg='--force --grace-period 0' && \
alias k=kubectl && source <(kubectl completion bash | sed 's/kubectl/k/g') && \
echo "source <(kubectl completion bash)" >> $HOME/.bashrc && \
echo -e 'set et nu sts=2 sw=2 ts=2' >> ~/.vimrc

EXPLAINED
set expandtab #never see \t again in your file - expands tab keypresses to space
set number
set softtabstop #of whitespace cols a tab/backspace keypress is worth
set shiftwidth=2 #of whitespace cols a "lvl of indent" is worth
set tabstop=2 #of whitespace cols a tab counts for

```
</p>
</details>

<details><summary>connectivity test commands</summary>
<p>
  
```bash
k -n ??? run tmp --restart=Never --rm -i --image=nginx:alpine -i -- curl -m 5 <?>
<?> could be: 
  http://<svcName.namespace>:<port#>
  ClusterIP (from "k -n ??? get pod -o wide")
k -n ??? run tmp --restart=Never --rm -i --image=busybox -i -- wget -O- <?>
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
<p>1. Delete release internal-issue-report-apiv1</p>
<p>2. Upgrade release internal-issue-report-apiv2 to any newer version of chart bitnami/nginx available</p>
<p>3. Install a new release internal-issue-report-apache of chart bitnami/apache. The Deployment should have two replicas, set these via Helm-values during install</p>
<p>4. There seems to be a broken release, stuck in pending-install state. Find it and delete it</p>
</summary>
<p>
  
```bash
helm -n mercury uninstall internal-issue-report-apiv1
helm repo list; helm repo update; helm search repo nginx; helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
helm show values bitnami/apache | yq e; helm -n mercury install internal-issue-report-apache bitnami/apache --set replicaCount=2; k -n mercury get deploy internal-issue-report-apache
helm -n mercury list -a | helm -n mercury uninstall internal-issue-report-daniel
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
exec:                                    # add
  command:                               # add
  - sh                                   # add
  - -c                                   # add
  - cat /tmp/ready                       # add
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
k -n moon create secret generic secret1 --from-literal user=test --from-literal pass=pwd
k -n moon -f /opt/course/14/secret2.yaml create
cp /opt/course/14/secret-handler.yaml /opt/course/14/secret-handler-new.yaml
vim /opt/course/14/secret-handler-new.yaml #add the following at the indicated indent level:
#spec.volumes
- name: secret2-volume
  secret:
    secretName: secret2
#spec.containers.volumemounts
- name: secret2-volume
  mountPath: /tmp/secret2
#spec.containers.env
 - name: SECRET1_USER
   valueFrom:
     secretKeyRef:
       name: secret1
       key: user
 - name: SECRET1_PASS
   valueFrom:
     secretKeyRef:
       name: secret1
       key: pass
k delete pod -n moon secret-handler
k create -f /opt/course/14/secret-handler-new.yaml
#verify with:
k -n moon exec secret-handler -- env
k -n moon exec secret-handler -- find /tmp/secret2
k -n moon exec secret-handler -- cat /tmp/secret2/key
```
</p>
</details>

### Q15 | ConfigMap, Configmap-Volume ###
<details><summary>
Team Moonpie has a nginx server Deployment called web-moon in Namespace moon. Someone started configuring it but it was never completed. To complete please create a ConfigMap called configmap-web-moon-html containing the content of file /opt/course/15/web-moon.html under the data key-name index.html.
The Deployment web-moon is already configured to work with this ConfigMap and serve its content. Test the nginx configuration for example using curl from a temporary nginx:alpine Pod.
</summary>
<p>
  
```bash
k -n moon create configmap configmap-web-moon-html --from-file=index.html=/opt/course/15/web-moon.html
k -n moon rollout restart deploy web-moon # MAY need to delete/recreate for pods to deploy
k -n moon get pod -o wide # get <test cluster IP>
k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl <test cluster IP>
```
</p>
</details>

### Q16 | Logging sidecar ###
<details><summary>
1of3 The Tech Lead of Mercury2D decided its time for more logging, to finally fight all these missing data incidents. There is an existing container named cleaner-con in Deployment cleaner in Namespace mercury. This container mounts a volume and writes logs into a file called cleaner.log. The yaml for the existing Deployment is available at /opt/course/16/cleaner.yaml. Persist your changes at /opt/course/16/cleaner-new.yaml but also make sure the Deployment is running.
</summary>
<p>
  
```bash
cp /opt/course/16/cleaner.yaml /opt/course/16/cleaner-new.yaml
```
</p>
</details>

<details><summary>
2of3 Create a sidecar container named logger-con, image busybox:1.31.0, which mounts the same volume and writes the content of cleaner.log to stdout, you can use the tail -f command for this. This way it can be picked up by kubectl logs.
</summary>
<p>
  
```bash
#vim into cleaner-new.yml and add under spec.template.spec.containers:
- name: logger-con
  image: busybox:1.31.0
  command: ["sh", "-c", "tail -f /var/log/cleaner/cleaner.log"]
  volumeMounts:
  - name: logs
    mountPath: /var/log/cleaner
k apply -f /opt/course/16/cleaner-new.yaml #'...but also make sure the Deployment is running'
```
</p>
</details>

<details><summary>
3of3 Check if the logs of the new container reveal something about the missing data incidents.
</summary>
<p>
  
```bash
k -n mercury logs cleaner-<dep>-<pod> -c logger-con
```
</p>
</details>

### Q17 | InitContainer ###
<details><summary>
1of2 Last lunch you told your coworker from department Mars Inc how amazing InitContainers are. Now he would like to see one in action. There is a Deployment yaml at /opt/course/17/test-init-container.yaml. This Deployment spins up a single Pod of image nginx:1.17.3-alpine and serves files from a mounted volume, which is empty right now.
Create an InitContainer named init-con which also mounts that volume and creates a file index.html with content check this out! in the root of the mounted volume. For this test we ignore that it doesn't contain valid html.
The InitContainer should be using image busybox:1.31.0. 
</summary>
<p>

```bash
cp /opt/course/17/test-init-container.yaml ~/17_test-init-container.yaml
vim 17_test-init-container.yaml #add below under spec.template.spec:
initContainers:
- name: init-con
  image: busybox:1.31.0
  command: ['sh', '-c', 'echo "check this out!" > /tmp/web-content/index.html']
  volumeMounts:
  - name: web-content
    mountPath: /tmp/web-content
k create -f 17_test-init-container.yaml
```
</p>
</details>

<details><summary>
2of2 Test your implementation for example using curl from a temporary nginx:alpine Pod.
</summary>

```bash
k -n mars get pod -o wide # get <test cluster IP>
k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl <test cluster IP>
```
</p>
</details>

### Q18 | Service misconfiguration ###
<details><summary>
There seems to be an issue in Namespace mars where the ClusterIP service manager-api-svc should make the Pods of Deployment manager-api-deployment available inside the cluster.
You can test this with curl manager-api-svc.mars:4444 from a temporary nginx:alpine Pod. Check for the misconfiguration and apply a fix.
</summary>
<p>
  
```bash
1of2:Diagnose
k -n mars get all #All pods STATUS: "Running"; gets you svc NAME:PORT and CLUSTER-IP for later
k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 manager-api-svc:4444 #can't connect to svc
k -n mars get ep #no eps
k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 <test cluster IP> #pod connects
```
</p>
</details>

<details><summary> ... apply a fix.
</summary>
<p>
  
```bash
2of2
k -n mars edit svc #spec.selector should be manager-api-pod
k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 manager-api-svc:4444 #svc works now
k -n mars get ep #eps show now
```
</p>
</details>

### Q19 | Service ClusterIP->NodePort ###
<details><summary>
1of4 In Namespace jupiter you'll find an apache Deployment (with one replica) named jupiter-crew-deploy and a ClusterIP Service called jupiter-crew-svc which exposes it. Change this service to a NodePort one to make it available on all nodes on port 30100.
</summary>
<p>

```bash
k -n jupiter run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 jupiter-crew-svc:8080 #ClusterIP svc jupiter-crew-svc does work
k -n jupiter edit svc jupiter-crew-svc
nodePort: 30100 #spec.ports
type: NodePort #spec
```
</p>
</details>

<details><summary>
2of4 Test the NodePort Service using the internal IP of all available nodes and the port 30100 using curl, you can reach the internal node IPs directly from your main terminal. 
</summary>
<p>
  
```bash
#must know for ports!: https://nigelpoulton.com/explained-kubernetes-service-ports/?force_isolation=true
k -n jupiter run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 jupiter-crew-svc:8080 #ClusterIP svc is still internally reachable
```
</p>
</details>

<details><summary>
3of4 On which nodes is the Service reachable? 
</summary>
<p>
  
```bash
k get nodes -o wide #get <masterIP> and <workerIP> for testing whether svc is reachable
curl <masterIP>:30100 && curl <workerIP>:30100 # html><body><h1>It works!</h1></body></html>
```
</p>
</details>

<details><summary>
4of4 On which node is the Pod running?
</summary>
<p>
  
```bash
k -n jupiter get pod jupiter-crew-deploy-<dep>-<pod> -o yaml | grep nodeName #confirm which node pod runs on
```
</p>
</details>

### Q20 | NetworkPolicy ###
<details><summary>
1of2 In Namespace venus you'll find two Deployments named api and frontend. Both Deployments are exposed inside the cluster using Services. Create a NetworkPolicy named np1 which restricts outgoing tcp connections from Deployment frontend and only allows those going to Deployment api. Make sure the NetworkPolicy still allows outgoing traffic on UDP/TCP ports 53 for DNS resolution.
</summary>
<p>
  
```bash
k -n venus exec frontend-<dep>-<pod> -- wget -O- www.google.com #works
k -n venus exec frontend-<dep>-<pod> -- wget -O- api:2222 #works
vim 20_netpol.yml #copy from documentation and edit as shown
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: np1
  namespace: venus
spec:
  podSelector:
    matchLabels:
      id: frontend    # label of the pods this policy should be applied on
  policyTypes:
  - Egress            # only control
  egress:
  - to:               # rule 1 - egress only to pods with api label
    - podSelector:   
        matchLabels:
          id: api
  - ports:            # rule 2 - allow UDP/TCP DNS ("-" is REQUIRED for logical OR (else would be AND; would only be 1 rule not 2).
    - port: 53        # allow DNS UDP
      protocol: UDP
    - port: 53        # allow DNS TCP
      protocol: TCP
k create -f 20_netpol.yml
```
</p>
</details>

<details><summary>
2of2 Test using: wget www.google.com and wget api:2222 from a Pod of Deployment frontend.
</summary>
<p>
  
```bash
k -n venus exec frontend-<dep>-<pod> -- wget -O- www.google.com #no longer working
k -n venus exec frontend-<dep>-<pod> -- wget -O- api:2222 #works
```
</p>
</details>

### Q21 | Requests and Limits, ServiceAccount ###
<details><summary>
Team Neptune needs 3 Pods of image httpd:2.4-alpine, create a Deployment named neptune-10ab for this. The containers should be named neptune-pod-10ab. Each container should have a memory request of 20Mi and a memory limit of 50Mi. Team Neptune has its own ServiceAccount neptune-sa-v2 under which the Pods should run. The Deployment should be in Namespace neptune.
</summary>
<p>
  
```bash
k -n neptune create deploy neptune-10ab --image=httpd:2.4-alpine --replicas=3 $dy > 21.yaml
vim 21.yml
#spec.template.spec:
serviceAccountName: neptune-sa-v2 
#spec.template.spec.containers:
name: neptune-pod-10ab  # change
resources:              # add
  limits:               # add
    memory: 50Mi        # add
  requests:             # add
    memory: 20Mi        # add

```
</p>
</details>

### Q22 | Labels, Annotations ###
<details><summary>
Team Sunny needs to identify some of their Pods in namespace sun. They ask you to add a new label protected: true to all Pods with an existing label type: worker or type: runner. Also add an annotation protected: do not delete this pod to all Pods having the new label protected: true.
</summary>
<p>
  
```bash
k -n sun label pod -l "type in (worker,runner)" protected=true
k -n sun annotate pod -l protected=true protected="do not delete this pod"
```
</p>
</details>

### Preview Question 1 ###
<details><summary>
In Namespace pluto there is a Deployment named project-23-api. It has been working okay for a while but Team Pluto needs it to be more reliable. Implement a liveness-probe which checks the container to be reachable on port 80. Initially the probe should wait 10, periodically 15 seconds.
The original Deployment yaml is available at /opt/course/p1/project-23-api.yaml. Save your changes at /opt/course/p1/project-23-api-new.yaml and apply the changes.
</summary>
<p>
  
```bash
cp /opt/course/p1/project-23-api.yaml /opt/course/p1/project-23-api-new.yaml
vim /opt/course/p1/project-23-api-new.yaml #add below under under spec.template.spec.containers
livenessProbe:
  tcpSocket:
    port: 80
  initialDelaySeconds: 10
  periodSeconds: 15
k delete deploy -n pluto project-23-api 
k create -f /opt/course/p1/project-23-api-new.yaml
```
</p>
</details>

### Preview Question 2 ###
<details><summary>
Team Sun needs a new Deployment named sunny with 4 replicas of image nginx:1.17.3-alpine in Namespace sun. The Deployment and its Pods should use the existing ServiceAccount sa-sun-deploy.
Expose the Deployment internally using a ClusterIP Service named sun-srv on port 9999. The nginx containers should run as default on port 80. The management of Team Sun would like to execute a command to check that all Pods are running on occasion. Write that command into file /opt/course/p2/sunny_status_command.sh. The command should use kubectl.
</summary>
<p>
  
```bash
k create deploy sunny -n sun --image=nginx:1.17.3-alpine --replicas=4 $dy > pq2.ym
pq2.yml
vim pq2.yml # add "serviceAccountName: sa-sun-deploy" under spec.template.spec
k create -f pq2.yml
k expose deploy -n sun sunny --type=ClusterIP --port=80 --target-port=9999 --name=sun-srv
echo "kubectl get pods -l app=sunny -n sun" > /opt/course/p2/sunny_status_command.sh
```
</p>
</details>

### Preview Question 3 ###
<details><summary>
Management of EarthAG recorded that one of their Services stopped working. Dirk, the administrator, left already for the long weekend. All the information they could give you is that it was located in Namespace earth and that it stopped working after the latest rollout. All Services of EarthAG should be reachable from inside the cluster.
Find the Service, fix any issues and confirm its working again. Write the reason of the error into file /opt/course/p3/ticket-654.txt so Dirk knows what the issue was.
</summary>
<p>
  
```bash

```
</p>
</details>

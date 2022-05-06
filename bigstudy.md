## Study Path: ##
<details><summary></summary>
https://cloudacademy.com/learning-paths/certified-kubernetes-application-developer-ckad-exam-preparation-1-3086/?fromTp=true
</p></details>

# Exam 1: Core Concepts #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab/ckad-practice-exam-core-concepts/?context_resource=lp&context_id=3086
</p></details>

<details><summary>Env Config:</summary>
<p>
  
```bash
export dy='--dry-run=client -o yaml' fg='--force --grace-period 0' && \
alias k=kubectl && source <(kubectl completion bash | sed 's/kubectl/k/g') && \
echo -e 'set nu et sts=2 sw=2 ts=2' >> ~/.vimrc
```
 
</p>
</details>

### Check 1: Create and Configure a Basic Pod ###
<details><summary>
Create a Pod in the cre Namespace with the following configuration: <ul>
<li>The Pod is named basic</li>
<li>The Pod uses the nginx:stable-alpine-perl image for its only container</li>
<li>Restart the Pod only OnFailure</li>
<li>Ensure port 80 is open to TCP traffic</li></ul></summary>
<p>
  
```bash
k run -n cre --image=nginx:stable-alpine-perl --restart=OnFailure --port=80 basic
```
  
</p>
</details>

### Check 2: Create a Namespace and Launch a Pod within it with Labels ###
Create a new Namespace named workers and within it launch a Pod with the following configuration: <ul>
<li>The Pod is named worker</li>
<li>The Pod uses the busybox image for its only container</li>
<li>Restart the Pod Never</li>
<li>Command: /bin/sh -c "echo working... && sleep 3600"</li>
<li>Label 1: company=acme</li>
<li>Label 2: speed=fast</li>
<li>Label 3: type=async</li></ul>

<details><summary>show</summary>
<p>
  
```bash
k create ns workers
k run -n workers worker --image=busybox --labels="company=acme,speed=fast,type=async" -- /bin/sh -c "echo working... && sleep 3600"}
```
  
</p>
</details>

### Check 3: Update the Label on a Running Pod ###
<details><summary>The ca200 namespace contains a running Pod named compiler. Without restarting the pod, update and change it's language label from java to python.</summary>
<p>
  
```bash
k label --overwrite=true pod compiler -n ca200 language=python
```
  
</p>
</details>

### Check 4: Get the Pod IP Address using JSONPath ###
<details><summary>Discover the Pod IP address assigned to the pod named ip-podzoid running in the ca300 namespace using JSONPath (hint: use -o jsonpath). Once you've established the correct kubectl command to do this, save the command (not the result) into a file at /home/ubuntu/podip.sh</summary>
<p>
  
```bash
cat << EOF > /home/ubuntu/podip.sh
kubectl get pods -n ca300 -o jsonpath="{.items[*].status.podIP}"
EOF
```
  
</p>
</details>

### Check 5: Generate Pod YAML Manifest File ###
Generate a new Pod manifest file which contains the following configuration:
<ul><li>Pod name: borg1</li>
<li>Namespace to launch in: core-system</li>
<li>Container image: busybox</li>
<li>Command: /bin/sh -c "echo borg.running... && sleep 3600"</li>
<li>Restart policy: Always</li>
<li>Pod label: platform=prod</li>
<li>Environment variable: system=borg</li></ul>
Save the resulting manifest to the following location: /home/ubuntu/pod.yaml

<details><summary>show</summary>
<p>
  
```bash
k run -n core-system borg1 --image=busybox --restart=Always --labels="platform=prod" --env system=borg $dy -- /bin/sh -c "echo borg.running... && sleep 3600" > /home/ubuntu/pod.yaml
```
  
</p>
</details>

### Check 6: Launch Pod and Configure its Termination Shutdown Time ###
Launch a new web server Pod in the sys2 namespace with the following configuration:
<ul><li>Pod name: web-zeroshutdown</li>
<li>Container image: nginx</li>
<li>Restart policy: Never</li></ul>
Ensure the pod is configured to terminate immediately when requested to do so by configuring it's terminationGracePeriodSeconds setting.

<details><summary>show</summary>
<p>
  
```bash
k run web-zeroshutdown -n sys2 --image=nginx --restart=Never --port=80 $dy > pod-zeroshutdown.yaml
k explain pod.spec
vim pod-zeroshutdown.yaml # terminationGracePeriodSeconds: 0 at .spec
kubectl apply -f pod-zeroshutdown.yaml
```
  
</p>
</details>

# Exam 2: Configuration #
<details><summary>Exam link</summary>
https://cloudacademy.com/lab/ckad-practice-exam-configuration/?context_resource=lp&context_id=3086
</p></details>

### Check 1: Create and Consume a Secret using a Volume ###
<p>Create a secret named app-secret in the yqe Namespace that stores key-value pair of password=abnaoieb2073xsj</p>
<p>Create a Pod in the yqe Namespace that consumes the app-secret Secret using a Volume that mounts the Secret in the /etc/app directory. The Pod should be named app and run a memcached container.</p>

<details><summary>show</summary>
<p>
  
```bash
k -n yqe create secret generic --from-literal=password=abnaoieb2073xsj app-secret
k -n yqe run app --image=memcached $dy > 1_pod.yml
vim 1_pod.yml
apiVersion: v1
kind: Pod
metadata:
  name: app
spec:
  containers:
  - name: app
    image: memcached #add/edit below
    volumeMounts:
    - name: secret
      mountPath: "/etc/app"
  volumes:
  - name: secret
    secret:
      secretName: app-secret
```
  
</p>
</details>

### Check 2: Update Deployment with New Service Account ###
A Deployment named secapp has been created in the app namespace and currently uses the default ServiceAccount. Create a new ServiceAccount named secure-svc in the app namespace and then use it within the existing secapp Deployment, ensuring that the replicas now run with it.

<details><summary>show</summary>
<p>
  
```bash
k create sa -n app secure-svc
k explain deploy --recursive | less #find placement of "serviceAccountName" object (same as .spec.container)
k edit deploy secapp -n app #insert name of created sa at appropriate spot in manifest file
```
  
</p>
</details>

### Check 3: Pod Security Context Configuration ###
Create a pod named secpod in the dnn namespace which includes 2 containers named c1 and c2. Both containers must be configured to run the bash image, and should execute the command /usr/local/bin/bash -c sleep 3600. Container c1 should run as user ID 1000, and container c2 should run as user ID 2000. Both containers should use file system group ID 3000.
<details><summary>show</summary>
<p>
  
```bash 
k run -n dnn secpod --image=bash $dy --command -- /usr/local/bin/bash -c sleep 3600 > 3_pod.yml
vim 3_pod.yml:
apiVersion: v1
kind: Pod 
metadata:
  name: secpod
  namespace: dnn 
spec:
  securityContext:
    fsGroup: 3000
  containers:
  - args:
    - usr/local/bin/bash
    - -c
    - sleep 3600
    image: bash
    name: c1
    securityContext:
      runAsUser: 1000
  - args:
    - usr/local/bin/bash
    - -c
    - sleep 3600
    image: bash
    name: c2
    securityContext:
      runAsUser: 2000
```
  
</p>
</details>

### Check 4: Pod Resource Constraints ###
Create a new Pod named web1 in the ca100 namespace using the nginx image. Ensure that it has the following 2 labels env=prod and type=processor. Configure it with a memory request of 100Mi and a memory limit at 200Mi. Expose the pod on port 80.
<details><summary>show</summary>
<p>
  
```bash
k run -n ca100 web1 --image=nginx --labels="env=prod,type=processor" --port=80 $dy > 4.yml
vim 4.yml
apiVersion: v1
kind: Pod 
metadata:
  labels:
    env: prod
    type: processor
  name: web1
  namespace: ca100
spec:
  containers:
  - image: nginx
    name: web1
    ports:
    - containerPort: 80
    resources: {} 	# Replace/add from here down as marked with "##"
	resources:			##
	  requests:			##
	    memory: 100Mi	##
	  limits:			##
	    memory: 200Mi	##
```
  
</p>
</details>

### Check 5: Create a Pod with Config Map Environment Vars ###
Create a new ConfigMap named config1 in the ca200 namespace. The new ConfigMap should be created with the following 2 key/value pairs:
<ul><li>COLOUR=red</li>
<li>SPEED=fast</li></ul>
Launch a new Pod named redfastcar in the same ca200 namespace, using the image busybox. The redfastcar pod should expose the previous ConfigMap settings as environment variables inside the container. Configure the redfastcar pod to run the command:  /bin/sh -c "env | grep -E 'COLOUR|SPEED'; sleep 3600"
<details><summary>show</summary>
<p>
	
```bash
#1 Create ConfigMap
k create cm config1 -n ca200 --from-literal COLOUR=red --from-literal SPEED=fast
#2 Run pod
k run -n ca200 redfastcar --image=busybox $dy --command -- /bin/sh -c "env | grep -E 'COLOUR|SPEED'; sleep 3600" > 5.yml
#3 vim 5.yml and add ("##") configMap env configuration
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: redfastcar
  name: redfastcar
  namespace: ca200
spec:
  containers:
  - command:
    - /bin/sh
    - -c
    - env | grep -E 'COLOUR|SPEED'; sleep 3600
    image: busybox
    name: redfastcar
    resources: {}
    envFrom:				##add
    - configMapRef:			##add
        name: config1			##add
```
	
</p>
</details>

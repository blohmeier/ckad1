### Check 1: Create and Configure a Basic Pod ###
Create a Pod in the cre Namespace with the following configuration: <br />
The Pod is named basic
The Pod uses the nginx:stable-alpine-perl image for its only container
Restart the Pod only OnFailure
Ensure port 80 is open to TCP traffic
<details><summary>show</summary>
<p>
  
```bash
k run -n cre --image=nginx:stable-alpine-perl --restart=OnFailure --port=80 basic}
```
  
</p>
</details>

Check 2: Create a Namespace and Launch a Pod within it with Labels
Create a new Namespace named workers and within it launch a Pod with the following configuration:
The Pod is named worker
The Pod uses the busybox image for its only container
Restart the Pod Never
Command: /bin/sh -c "echo working... && sleep 3600"
Label 1: company=acme
Label 2: speed=fast
Label 3: type=async
{
k create ns workers
kubectl run -n workers worker --image=busybox --labels="company=acme,speed=fast,type=async" -- /bin/sh -c "echo working... && sleep 3600"}
◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
Check 3: Update the Label on a Running Pod
The ca200 namespace contains a running Pod named compiler. Without restarting the pod, update and change it's language label from java to python.
{
k label --overwrite=true pod compiler -n ca200 language=python}
◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
Check 4: Get the Pod IP Address using JSONPath
Discover the Pod IP address assigned to the pod named ip-podzoid running in the ca300 namespace using JSONPath (hint: use -o jsonpath). Once you've established the correct kubectl command to do this, save the command (not the result) into a file located here: /home/ubuntu/podip.sh
{
cat << EOF > /home/ubuntu/podip.sh
kubectl get pods -n ca300 -o jsonpath="{.items[*].status.podIP}"
EOF
}
◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
Check 5: Generate Pod YAML Manifest File
Generate a new Pod manifest file which contains the following configuration:
Pod name: borg1
Namespace to launch in: core-system
Container image: busybox
Command: /bin/sh -c "echo borg.running... && sleep 3600"
Restart policy: Always
Pod label: platform=prod
Environment variable: system=borg
Save the resulting manifest to the following location: /home/ubuntu/pod.yaml
{
k run -n core-system borg1 --image=busybox --restart=Always --labels="platform=prod" --env system=borg $dy -- /bin/sh -c "echo borg.running... && sleep 3600" > /home/ubuntu/pod.yaml
}
◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
Check 6: Launch Pod and Configure its Termination Shutdown Time
Launch a new web server Pod in the sys2 namespace with the following configuration:
Pod name: web-zeroshutdown
Container image: nginx
Restart policy: Never
Ensure the pod is configured to terminate immediately when requested to do so by configuring it's terminationGracePeriodSeconds setting.
{
k run web-zeroshutdown -n sys2 --image=nginx --restart=Never --port=80 $dy > pod-zeroshutdown.yaml
k explain pod.spec
vim pod-zeroshutdown.yaml
kubectl apply -f pod-zeroshutdown.yaml
}



◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
ALTERNATE ANSWERS
◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
◄▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬►
Check 4: NOTE: Though the below is functionally the same, MUST BE IDENTICAL SYNTAX (e.g., even "kubectl") to be correct, so below was not accepted.
k get pod ip-podzoid -n ca300 -o yaml | sed -n 's/podIP: //p' | tail -n +2

CHECK 5 - WHAT'S THE DIFFERENCE? TOP WRONG, BOTTOM RIGHT?

ubuntu@ip-10-0-128-5:~$ k run borg1 -n core-system --image=busybox --labels="platform=pod" --restart=Always --env system=borg $dy -- /bin/sh -c "echo borg.running... && sleep 3600"
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    platform: pod
  name: borg1
  namespace: core-system
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - echo borg.running... && sleep 3600
    env:
    - name: system
      value: borg
    image: busybox
    name: borg1
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

ubuntu@ip-10-0-128-5:~$ k run -n core-system borg1 --image=busybox --restart=Always --labels="platform=prod" --env system=borg $dy -- /bin/sh -c "echo borg.running... && sleep 3600"
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    platform: prod
  name: borg1
  namespace: core-system
spec:
  containers:
  - args:
    - /bin/sh
    - -c
    - echo borg.running... && sleep 3600
    env:
    - name: system
      value: borg
    image: busybox
    name: borg1
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Always
status: {}

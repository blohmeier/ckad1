### Connectivity Testing ###
<p>k -n ?1? run tmp --restart=Never --rm -i --image=nginx:alpine -i -- curl -m 5 ?2? </p>
EXAMPLE:
k run tmp --restart=Never --rm --image=nginx:alpine -i -- curl http://project-plt-6cc-svc.pluto:3333 > /opt/course/10/service_test.html #pipe results from confirming cnxn w/tmp pod

<p>k -n ?1? run tmp --restart=Never --rm -i --image=busybox -i -- wget -O- ?2? </p>
EXAMPLE:

<details><summary>?2? could be:</summary>
<p>
  
```bash  
http://<svcName.namespace>:<port#>
ClusterIP, e.g. from "k -n ??? get pod -o wide"
```
</p>
</details>
  
## Find the pod with the error ##
<p>k -n neptune describe pod ?depName?-?depHash?-?podHash? | grep -i error </p>
<p>k -n neptune describe pod ?depName?-?depHash?-?podHash? | grep -i image </p>

## Pull info from cluster ##
k get pod pod1 -o jsonpath="{.status.phase}"
awk '{print $1}'
k explain pod --recursive |  awk '/^[ ]{3,6}[[:alpha:]]/'
k get pod holy-api-7bbc86b7b5-2x9xx -o yaml > sample3.yaml; yq e '.status.podIP' sample3.yaml

## Create Resources ##
k -n neptune create job neb-new-job --image=busybox:1.31.0 $dy > /opt/course/3/job.yaml -- sh -c "sleep 2 && echo done"
k run pod6 --image=busybox:1.31.0 $dy --command -- sh -c "touch /tmp/ready && sleep 1d" > 6.yml
k -n pluto run project-plt-6cc-api --image=nginx:1.17.3-alpine --labels project=plt-6cc-api
k -n pluto expose pod project-plt-6cc-api --name project-plt-6cc-svc --port 3333 --target-port 80

## Deployment rollouts ##
k -n neptune rollout history deploy ?depName?
k -n neptune rollout undo deploy ?depName?

## Helm ##
helm repo list; helm repo update; help search repo <chart e.g. nginx>
#list current chart repos; update them, and search all for a <chart>
helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
#upgrade any deployment release to any newer available version of a repo/chart (e.g. bitnami/nginx is repo bitnami, chart nginx)

## Containers (e.g. Docker, Podman) ##
<details><summary>Build image using Docker, named registry.killer.sh:5000/sun-cipher, tagged as latest and v1-docker, push these to the registry. Build the image using Podman, named registry.killer.sh:5000/sun-cipher, tagged as v1-podman, push it to the registry.</summary>
<p>
  
```bash  
sudo docker build -t registry.killer.sh:5000/sun-cipher:latest -t registry.killer.sh:5000/sun-cipher:v1-docker .
sudo docker push registry.killer.sh:5000/sun-cipher:latest
sudo docker push registry.killer.sh:5000/sun-cipher:v1-docker
podman build -t registry.killer.sh:5000/sun-cipher:v1-podman .
podman push registry.killer.sh:5000/sun-cipher:v1-podman
```
</p>
</details>

  

<details><summary>Run a container using Podman, which keeps running in the background, named sun-cipher using image registry.killer.sh:5000/sun-cipher:v1-podman. Run the container from k8s@terminal and not root@terminal</summary>
<p>
  
```bash
su - k8s #only if not already k8s@terminal. Or can just 'exit' from root. To go back to root, sudo su w/no pw.
podman run -d --name sun-cipher registry.killer.sh:5000/sun-cipher:v1-podman
```
</p>
</details>
 
<details><summary>Write the logs your container sun-cipher produced into /opt/course/11/logs. Then write a list of all running Podman containers into /opt/course/11/containers.</summary>
<p>
  
```bash  
podman ps > /opt/course/11/containers
podman logs sun-cipher > /opt/course/11/logs
```
</p>
</details>

<details><summary>?sample visible text here?</summary>
<p>
  
```bash  
?sample hidden text here?
```
</p>
</details>

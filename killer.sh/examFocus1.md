### Connectivity Testing ###
<p>k -n ?1? run tmp --restart=Never --rm -i --image=nginx:alpine -i -- curl -m 5 ?2? </p>
<p>k -n ?1? run tmp --restart=Never --rm -i --image=busybox -i -- wget -O- ?2? </p>
# ?2? could be: 
# http://<svcName.namespace>:<port#>
# ClusterIP, e.g. from "k -n ??? get pod -o wide"

## Find the pod with the error ##
k -n neptune describe pod api-new-c32-<dep>-<pod> | grep -i error; k -n neptune describe pod api-new-c32-7d64747c87-zh648 | grep -i image


## Pull info from cluster ##
k get pod pod1 -o jsonpath="{.status.phase}"
awk '{print $1}'
k explain pod --recursive |  awk '/^[ ]{3,6}[[:alpha:]]/'
k get pod holy-api-7bbc86b7b5-2x9xx -o yaml > sample3.yaml; yq e '.status.podIP' sample3.yaml

## Create Resources ##
k -n neptune create job neb-new-job --image=busybox:1.31.0 $dy > /opt/course/3/job.yaml -- sh -c "sleep 2 && echo done"
k run pod6 --image=busybox:1.31.0 $dy --command -- sh -c "touch /tmp/ready && sleep 1d" > 6.yml

## Deployment rollouts ##


## Helm ##
helm repo list; helm repo update; help search repo <chart e.g. nginx>
#list current chart repos; update them, and search all for a <chart>
helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
#upgrade any deployment release to any newer available version of a repo/chart (e.g. bitnami/nginx is repo bitnami, chart nginx)

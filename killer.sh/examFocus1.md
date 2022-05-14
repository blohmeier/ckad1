#### Testing ####
k -n ??? run tmp --restart=Never --rm -i --image=nginx:alpine -i -- curl -m 5 <?>
k -n ??? run tmp --restart=Never --rm -i --image=busybox -i -- wget -O- <?>
<?> could be: 
  http://<svcName.namespace>:<port#>
  ClusterIP (from "k -n ??? get pod -o wide")

### Pull info from cluster ###
k get pod pod1 -o jsonpath="{.status.phase}"


### Create resources ###
k -n neptune create job neb-new-job --image=busybox:1.31.0 $dy > /opt/course/3/job.yaml -- sh -c "sleep 2 && echo done"

## Helm ###
helm repo list; helm repo update; help search repo <chart e.g. nginx>; helm -n mercury upgrade internal-issue-report-apiv2 bitnami/nginx
#upgrade any release to any newer available version of a repo/chart (e.g. bitnami/nginx is repo bitnami, chart nginx)

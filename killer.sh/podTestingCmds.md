14
```
#verify 1of3:
k -n moon exec secret-handler -- env | grep SECRET1 #should yield:
SECRET1_USER=test
SECRET1_PASS=pwd
#verify 2of3:
k -n moon exec secret-handler -- find /tmp/secret2 #should yield:
/tmp/secret2
/tmp/secret2/..data
/tmp/secret2/key
/tmp/secret2/..2019_09_11_09_03_08.147048594
/tmp/secret2/..2019_09_11_09_03_08.147048594/key
#verify 3of3:
k -n moon exec secret-handler -- cat /tmp/secret2/key #should yield:
12345678
```
15
```
k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl "ClusterIP from 'k -n moon get pod -o wide'"
```
17
```
k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl "ClusterIP from 'k -n mars get pod -o wide'"
```
18
```
k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 "ClusterIP from 'k -n mars get pod -o wide'"
k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 "svc:port from 'k -n mars get svc'"
ABOVE: tmp created in correct ns. BELOW: tmp curls in to correct ns.
k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 "svc:port from 'k -n mars get svc'"
```
19
```
#Confirm svc works:
k -n jupiter run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 "svc:port from 'k -n jupiter get svc'"
#Determine 1) which nodes service is reachable on
curl "IP1:30100 from 'k get nodes -o wide'"; curl "IP2:30100 from 'k get nodes -o wide'"
#Determine 2) which nodes the pod runs on
k -n jupiter get pod -o wide
```
20
```
#b4 netpol: confirm each svc works inside cluster
k -n venus run tmp --restart=Never --rm -i --image=busybox -i -- wget -O- "1st svc:port from 'k -n venus get svc'"
k -n venus run tmp --restart=Never --rm --image=busybox -i -- wget -O- "2nd svc:port from 'k -n venus get svc'"
#b4 netpol: confirm can reach external names and api svc
k -n venus exec frontend-'dep'-'pod' -- wget -O- "given URL" #works
k -n venus exec frontend-'dep'-'pod' -- wget -O- "2nd svc:port from 'k -n venus get svc'" #works
#after netpol: using any existing Pod from the 'frontend' dep, confirm can NO LONGER reach external name but can STILL reach api svc
k -n venus exec frontend-'dep'-'pod' -- wget -O- "given URL" #no longer works
k -n venus exec frontend-'dep'-'pod' -- wget -O- "2nd svc:port from 'k -n venus get svc'" #still works
```

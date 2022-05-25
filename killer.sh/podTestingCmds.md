18
k -n mars get svc; k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 manager-api-svc:4444
k -n mars get pod -o wide; 
k -n mars run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 10.0.1.14
ABOVE: tmp created in correct ns. BELOW: tmp curls to correct ns.
k run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 manager-api-svc.mars:4444

19
Confirm svc works:
k -n jupiter run tmp --restart=Never --rm -i --image=nginx:alpine -- curl -m 5 jupiter-crew-svc:8080
Determine 1) which nodes service is reachable on 2) which nodes the pod runs on
k get nodes -o wide; curl IP1:30100; curl IP2:30100; k get pods -o wide

20
Check if each service works inside cluster
k -n venus run tmp --restart=Never --rm -i --image=busybox -i -- wget -O- frontend:80
k -n venus run tmp --restart=Never --rm --image=busybox -i -- wget -O- api:2222
Using any existing Pod from the 'frontend' dep, check if can reach external names and the api Service
k -n venus exec frontend-'dep'-'pod' -- wget -O- www.google.com
k -n venus exec frontend-'dep'-'pod' -- wget -O- api:2222

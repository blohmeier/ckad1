Question:
Create a redis deployment using the image redis:alpine with 1 replica and label app=redis. Expose it via a ClusterIP service called redis on port 6379. Create a new Ingress Type NetworkPolicy called redis-access which allows only the pods with label access=redis to access the deployment.
Correct Answer:
To create deployment:
kubectl create deployment redis --image=redis:alpine --replicas=1
To expose the deployment using ClusterIP:
kubectl expose deployment redis --name=redis --port=6379 --target-port=6379
To create ingress rule:
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: redis-access
  namespace: default
spec:
  podSelector:
    matchLabels:
       app: redis
  policyTypes:
  - Ingress
  ingress:
  - from:
    - podSelector:
        matchLabels:
          access: redis
    ports:
     - protocol: TCP
       port: 6379
My answer:
1 apiVersion: networking.k8s.io/v1
  2 kind: NetworkPolicy
  3 metadata:
  4   name: redis-access
  5 spec:
  6   podSelector:
  7     matchLabels:
  8   policyTypes:
  9     - Ingress
 10   ingress:
 11     - from:
 12         - podSelector:
 13             matchLabels:
 14               access: redis

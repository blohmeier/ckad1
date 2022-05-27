WRONG ONLY
1
```
CORRECT:
MINE:
```
4
```
CORRECT:
MINE:
```
5
```
CORRECT:
MINE:
```
6
```
CORRECT:
MINE:
```
8
```
CORRECT:
MINE:
```
9
```
CORRECT:
kind: PersistentVolume
apiVersion: v1
metadata:
  name: custom-volume
spec:
  accessModes: ["ReadWriteMany"]
  capacity:
    storage: 50Mi
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: /opt/data

MINE:
apiVersion: v1
kind: PersistentVolume
metadata:
  name: custom-volume
  labels:
    type: local
spec:
  capacity:
    storage: 50MiB
  accessModes:
  - ReadWriteMany
  hostPath:
    path: "/opt/data"
```

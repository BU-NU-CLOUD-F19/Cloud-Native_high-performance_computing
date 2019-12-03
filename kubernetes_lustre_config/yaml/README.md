### Demo steps for creating Lustre's MGS component on K8s
#### Step 0. Configure 'kubectl' and 'K8s cluster'

```
Install kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl/ 
Create K8s cluster - https://docs.projectcalico.org/v3.9/getting-started/kubernetes/
```
#### Step 1. Create K8s secret for Lustre's MGS component from it's startup script
```
kubectl create secret generic vmi-lustre-mgs-secret --from-file=userdata=lustre-mgs-startup.sh
```
#### Step 2. Create Persistent Volume for Lustre's MGS component
```
kubectl create -f pv-mgs.yaml
```
#### Step 3. Create Persistent Volume Claim for Lustre's MGS component
```
kubectl create -f pvc-mgs.yaml
```
#### Step 4. Create Lustre's MGS Virtual Machine
```
kubectl create -f centos7-lustre-mgs.yaml
```
#### Step 5. Validate Lustre's MGS Virtual Machine is up and running
```
kubectl get vmis
```

# Longhorn

Distributed block storage system for Kubernetes.

## Overview

Longhorn provides persistent storage for Kubernetes workloads with features like:
- Distributed replicated storage
- Snapshots and backups
- Volume cloning
- Disaster recovery

## Access UI

The Longhorn UI can be accessed via the configured ingress (if enabled):

```bash
# Port-forward if no ingress configured
kubectl port-forward -n longhorn-system svc/longhorn-frontend 8000:80

# Open http://localhost:8000
```

## Adding Disks to Nodes

To add additional disks to specific nodes, use the patch files in this directory:

```bash
# Node w-ns3058844
kubectl patch nodes.longhorn.io w-ns3058844 -n longhorn-system \
  --type merge --patch-file gitops/infra/longhorn/resources/add-disk-w-ns3058844.patch.yaml

# Node w-ns3048244
kubectl patch nodes.longhorn.io w-ns3048244 -n longhorn-system \
  --type merge --patch-file gitops/infra/longhorn/resources/add-disk-w-ns3048244.patch.yaml

# Node w-ns3106816
kubectl patch nodes.longhorn.io w-ns3106816 -n longhorn-system \
  --type merge --patch-file gitops/infra/longhorn/resources/add-disk-w-ns3106816.patch.yaml
```

## Usage

Create a PersistentVolumeClaim using Longhorn storage class:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: longhorn
  resources:
    requests:
      storage: 10Gi
```

## Verification

```bash
# Check Longhorn system
kubectl get pods -n longhorn-system

# View volumes
kubectl get pv
kubectl get pvc -A

# Check node disks
kubectl get nodes.longhorn.io -n longhorn-system
```

## Reference

- [Longhorn Documentation](https://longhorn.io/docs/)
# Longhorn Disk Addition

This directory contains the configuration to deploy Longhorn with ArgoCD and a patch to add a disk to a specific node.

## Commands

To apply the disk addition patch to the Longhorn use the following command:

```bash
kubectl patch nodes.longhorn.io w-ns3058844 -n longhorn-system --type merge --patch-file gitops/infra/longhorn/add-disk-w-ns3058844.patch.yaml
```

```bash
kubectl patch nodes.longhorn.io w-ns3048244 -n longhorn-system --type merge --patch-file gitops/infra/longhorn/add-disk-w-ns3048244.patch.yaml
```

```bash
kubectl patch nodes.longhorn.io w-ns3106816 -n longhorn-system --type merge --patch-file gitops/infra/longhorn/add-disk-w-ns3106816.patch.yaml
```
# Metrics Server

Kubernetes Metrics Server for resource metrics collection.

## Overview

Metrics Server collects resource metrics (CPU, memory) from Kubelets and exposes them via the Kubernetes API for:
- Horizontal Pod Autoscaler (HPA)
- Vertical Pod Autoscaler (VPA)
- `kubectl top` commands

## Talos Linux Configuration

For Talos Linux clusters, additional components are required for proper certificate management:

```bash
# Install kubelet serving cert approver
kubectl apply -f https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml

# Install metrics-server (if not using ArgoCD)
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

**Note**: With ArgoCD deployment, only the cert approver is needed as metrics-server is managed by ArgoCD.

## Usage

```bash
# View node metrics
kubectl top nodes

# View pod metrics
kubectl top pods -A

# View pod metrics in specific namespace
kubectl top pods -n <namespace>
```

## Verification

```bash
# Check metrics-server is running
kubectl get pods -n kube-system -l app.kubernetes.io/name=metrics-server

# Test API endpoint
kubectl get apiservices | grep metrics
```

## Cleanup (if needed)

```bash
# Remove cert approver
kubectl delete -f https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml
```

## References

- [Metrics Server Chart](https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server)
- [Talos Documentation](https://docs.siderolabs.com/kubernetes-guides/monitoring-and-observability/deploy-metrics-server)

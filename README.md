# k8s_deploy

Kubernetes cluster management using GitOps with ArgoCD on Talos Linux (OVH infrastructure).

## Repository Structure

```
├── gitops/             # GitOps configurations
│   ├── infra/         # Infrastructure components
│   ├── app/           # Applications
│   └── bootstrap/     # Bootstrap manifests
├── argocd/            # ArgoCD installation values
└── archive/           # Archived configurations
```

## Deployed Components

### Infrastructure
- [**sealed-secrets**](gitops/infra/sealed-secrets/README.md) - Encrypted secrets management
- [**ingress-nginx**](gitops/infra/ingress-nginx/README.md) - Ingress controller
- [**longhorn**](gitops/infra/longhorn/README.md) - Distributed storage
- [**cloudflare-tunnel**](gitops/infra/cloudflare-tunnel/README.md) - External access & DNS

### Applications
- [**metrics-server**](gitops/app/metrics-server/README.md) - Resource metrics
- [**monitoring**](gitops/app/monitoring/README.md) - Prometheus & Grafana

## Quick Start

### 1. Install ArgoCD

See [ArgoCD installation guide](argocd/README.md).

### 2. Bootstrap the Cluster

See [Bootstrap guide](gitops/bootstrap/README.md).

### 3. Access ArgoCD

See [ArgoCD access instructions](argocd/README.md#access-argocd).

## Working with the Repository

### GitOps Workflow

See [GitOps documentation](gitops/README.md) for managing applications and infrastructure.

### Managing Secrets

See [Sealed Secrets documentation](gitops/infra/sealed-secrets/README.md).

### Exposing Services

See [Cloudflare Tunnel documentation](gitops/infra/cloudflare-tunnel/README.md).

## Useful Commands

```bash
# List all applications
kubectl get applications -n argocd

# Watch sync status
kubectl get applications -n argocd -w
```
# Bootstrap

Bootstrap configuration for initializing ArgoCD Applications in the cluster.

## Purpose

The bootstrap files create ArgoCD Applications that manage infrastructure components and applications using the App of Apps pattern.

## Bootstrap Order

### 1. Infrastructure First

```bash
kubectl apply -f gitops/bootstrap/bootstrap-infra.yaml
```

This deploys:
- Sealed Secrets Controller
- Ingress NGINX Controller
- Longhorn Storage
- Cloudflare Tunnel & External DNS

**Wait** for all infrastructure components to be ready before proceeding.

### 2. Applications

```bash
kubectl apply -f gitops/bootstrap/bootstrap-app.yaml
```

This deploys:
- Metrics Server
- Monitoring Stack (Prometheus, Grafana)

## Verification

```bash
# Check infrastructure applications
kubectl get applications -n argocd | grep infra-

# Check application layer
kubectl get applications -n argocd | grep app-

# Monitor sync status
kubectl get applications -n argocd -w
```

## Notes

- Infrastructure must be fully synced before deploying applications
- ArgoCD will automatically sync changes from the repository
- All applications use automated sync with prune and self-heal enabled
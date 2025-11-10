# ArgoCD Installation

This directory contains the Helm values configuration for ArgoCD deployment.

## Installation

```bash
# Add ArgoCD Helm repository
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Install ArgoCD
helm install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values argocd/values.yaml
```

## Access ArgoCD

```bash
# Get admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath='{.data.password}' | base64 -d

# Port-forward to access UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Open https://localhost:8080
# Username: admin
# Password: (from command above)
```

## Upgrade

```bash
helm upgrade argocd argo/argo-cd \
  --namespace argocd \
  --values argocd/values.yaml
```

## Cloudflare Tunnel Integration

To expose ArgoCD behind Cloudflare Tunnel with Ingress NGINX, the following annotations are required:

```yaml
nginx.ingress.kubernetes.io/ssl-passthrough: "true"
nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
```

**Note**: If you encounter `TOO_MANY_REDIRECTS` errors, ensure these annotations are properly configured.

## Uninstall

```bash
helm uninstall argocd -n argocd
kubectl delete namespace argocd
```

## Reference

- [ArgoCD Helm Chart](https://github.com/argoproj/argo-helm)


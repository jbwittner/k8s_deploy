# k8s_deploy

Kubernetes cluster management using GitOps with ArgoCD on Talos Linux (OVH infrastructure).

## Deployed Applications

### Infrastructure (`gitops/infra/`)
- **sealed-secrets**: Encrypted secrets management
- **ingress-nginx**: Ingress controller
- **longhorn**: Distributed storage
- **cloudflare-tunnel**: External access via Cloudflare

### Applications (`gitops/app/`)
- **metrics-server**: Resource metrics
- **monitoring**: Prometheus, Grafana, Alertmanager

## Managing Applications with ArgoCD

### Bootstrap the cluster

```bash
# 1. Install ArgoCD
kubectl create namespace argocd
helm repo add argo https://argoproj.github.io/argo-helm
helm install argocd argo/argo-cd -n argocd -f argocd/values.yaml

# 2. Bootstrap infrastructure
kubectl apply -f gitops/bootstrap/bootstrap-infra.yaml

# 3. Bootstrap applications
kubectl apply -f gitops/bootstrap/bootstrap-app.yaml
```

### Access ArgoCD UI

```bash
# Get admin password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d

# Port-forward
kubectl port-forward svc/argocd-server -n argocd 8080:443
# Open https://localhost:8080
```

### Add a new application

1. Create ArgoCD Application manifest in `gitops/app/<app-name>/<app-name>.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-<app-name>
  namespace: argocd
spec:
  project: default
  syncPolicy:
    automated:
      enabled: true
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=true
  source:
    repoURL: https://github.com/jbwittner/k8s_deploy
    targetRevision: main
    path: gitops/app/<app-name>/resources
  destination:
    server: https://kubernetes.default.svc
    namespace: <namespace>
```

2. Add to `gitops/app/kustomization.yaml`:

```yaml
resources:
  - <app-name>/<app-name>.yaml
```

3. Commit and push - ArgoCD will automatically sync

## Managing Secrets

Secrets are encrypted using Sealed Secrets:

```bash
# 1. Create secret (DON'T commit this file!)
kubectl create secret generic my-secret \
  --from-literal=password=supersecret \
  --dry-run=client -o yaml > my-secret.secret.yaml

# 2. Seal the secret
cat my-secret.secret.yaml | kubeseal \
  --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > my-secret.sealed-secret.yaml

# 3. Commit only the sealed secret
git add my-secret.sealed-secret.yaml
```

**Naming convention**:
- `*.secret.yaml` - Plain secrets (gitignored, never commit)
- `*.sealed-secret.yaml` - Encrypted secrets (commit to git)

## Exposing Services via Cloudflare Tunnel

To expose a service externally using Cloudflare Tunnel:

1. Create an Ingress with these annotations:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  namespace: my-namespace
  annotations:
    external-dns.alpha.kubernetes.io/cloudflare-proxied: "true"
    external-dns.alpha.kubernetes.io/hostname: myapp.wittnerlab.com
    external-dns.alpha.kubernetes.io/target: <tunnel-id>.cfargotunnel.com
spec:
  ingressClassName: nginx
  rules:
    - host: myapp.wittnerlab.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app
                port:
                  number: 80
```

2. External DNS will automatically create the DNS record in Cloudflare
3. Traffic flows: Cloudflare → Tunnel → Ingress NGINX → Service

**Important annotations**:
- `external-dns.alpha.kubernetes.io/hostname`: Your subdomain
- `external-dns.alpha.kubernetes.io/target`: Your Cloudflare tunnel endpoint
- `external-dns.alpha.kubernetes.io/cloudflare-proxied`: Enable Cloudflare proxy

## Useful Commands

```bash
# List all applications
kubectl get applications -n argocd

# Watch application status
kubectl get applications -n argocd -w

# Force sync an application
kubectl patch application <app-name> -n argocd --type merge -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{"revision":"HEAD"}}}'

# View sealed secrets
kubectl get sealedsecrets -A
```

## Documentation

- [Sealed Secrets](gitops/infra/sealed-secrets/README.md)
- [Cloudflare Tunnel](gitops/infra/cloudflare-tunnel/README.md)
- [Monitoring](gitops/app/monitoring/README.md)
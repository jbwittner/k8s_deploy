# GitOps Management

This directory contains all GitOps configurations managed by ArgoCD.

## Directory Structure

```
gitops/
├── infra/          # Infrastructure components
├── app/            # Applications
└── bootstrap/      # Bootstrap Applications
```

## GitOps Workflow

All cluster changes are made through Git commits. ArgoCD continuously monitors this repository and automatically syncs changes to the cluster.

### Principles

1. **Declarative**: All desired state is declared in Git
2. **Versioned**: Git provides history and rollback capability
3. **Automated**: ArgoCD handles synchronization automatically
4. **Auditable**: All changes are tracked in Git history

## Adding a New Application

### 1. Create Directory Structure

```bash
mkdir -p gitops/app/<app-name>/resources
```

### 2. Create ArgoCD Application Manifest

Create `gitops/app/<app-name>/<app-name>.yaml`:

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

For Helm-based applications:

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
    chart: <chart-name>
    repoURL: <helm-repo-url>
    targetRevision: <version>
    helm:
      values: |
        # Helm values here
  destination:
    server: https://kubernetes.default.svc
    namespace: <namespace>
```

### 3. Update Kustomization

Add to `gitops/app/kustomization.yaml`:

```yaml
resources:
  - <app-name>/<app-name>.yaml
```

### 4. Create Resources

Add Kubernetes manifests in `gitops/app/<app-name>/resources/`:

- Deployments
- Services
- ConfigMaps
- Sealed Secrets
- Ingress
- etc.

### 5. Commit and Push

```bash
git add gitops/app/<app-name>/
git commit -m "Add <app-name> application"
git push
```

ArgoCD will automatically detect and sync the new application.

## Adding Infrastructure Components

Follow the same process but use `gitops/infra/` directory:

1. Create `gitops/infra/<component-name>/`
2. Create ArgoCD Application manifest
3. Update `gitops/infra/kustomization.yaml`
4. Commit and push

**Note**: Prefix infrastructure applications with `infra-` (e.g., `infra-longhorn`)

## Application Structure Patterns

### Pattern 1: Plain Kubernetes Manifests

```
app-name/
├── app-name.yaml           # ArgoCD Application
├── README.md               # Documentation
└── resources/              # Kubernetes manifests
    ├── deployment.yaml
    ├── service.yaml
    └── ingress.yaml
```

### Pattern 2: Helm Chart with Additional Resources

```
app-name/
├── app-name.yaml           # ArgoCD Application with Helm source
├── README.md
└── resources/              # Additional resources not in chart
    └── sealed-secret.yaml
```

### Pattern 3: Multiple Sources (Helm + Resources)

```yaml
spec:
  sources:
    - chart: <chart-name>
      repoURL: <helm-repo>
      targetRevision: <version>
      helm:
        values: |
          # values
    - repoURL: https://github.com/jbwittner/k8s_deploy
      targetRevision: main
      path: gitops/app/<app-name>/resources
```

## Sync Policies

### Automated Sync

Applications use automated sync with:

- **prune**: Remove resources not defined in Git
- **selfHeal**: Revert manual changes to match Git

```yaml
syncPolicy:
  automated:
    enabled: true
    prune: true
    selfHeal: true
```

### Manual Sync

For critical infrastructure, you may prefer manual sync:

```yaml
syncPolicy:
  automated:
    enabled: false
```

Trigger sync via:
```bash
kubectl patch application <app-name> -n argocd \
  --type merge -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{"revision":"HEAD"}}}'
```

## Managing Secrets

Secrets must be encrypted using Sealed Secrets before committing to Git.

See [Sealed Secrets documentation](infra/sealed-secrets/README.md) for details.

## Verification

```bash
# List all applications
kubectl get applications -n argocd

# Check application status
kubectl get application <app-name> -n argocd

# View application details
kubectl describe application <app-name> -n argocd

# Watch sync status
kubectl get applications -n argocd -w
```

## Troubleshooting

### Application Not Syncing

```bash
# Check application status
kubectl describe application <app-name> -n argocd

# View sync errors
kubectl get application <app-name> -n argocd -o yaml

# Check ArgoCD logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-application-controller
```

### Manual Refresh

```bash
# Force refresh
kubectl patch application <app-name> -n argocd \
  --type merge -p '{"metadata":{"annotations":{"argocd.argoproj.io/refresh":"hard"}}}'
```

## Best Practices

1. **Naming Conventions**:
   - Infrastructure: `infra-<name>` (e.g., `infra-nginx`)
   - Applications: `app-<name>` (e.g., `app-monitoring`)

2. **Documentation**:
   - Always create a README.md for each component
   - Document configuration options and dependencies

3. **Secrets Management**:
   - Never commit plain secrets
   - Always use Sealed Secrets
   - Use `*.secret.yaml` for plain secrets (gitignored)
   - Use `*.sealed-secret.yaml` for encrypted secrets

4. **Testing**:
   - Test manifests with `kubectl apply --dry-run=client`
   - Validate with `kustomize build`
   - Check YAML syntax before committing

5. **Sync Options**:
   - Use `CreateNamespace=true` to automatically create namespaces
   - Consider `ServerSideApply=true` for large resources

## References

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Bootstrap Process](bootstrap/README.md)
- [Sealed Secrets](infra/sealed-secrets/README.md)

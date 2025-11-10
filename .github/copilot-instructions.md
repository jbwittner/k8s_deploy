# GitHub Copilot Instructions for k8s_deploy Repository

## Repository Overview

This repository contains Kubernetes deployment configurations for managing a personal Kubernetes cluster using GitOps principles. The deployment strategy uses ArgoCD for continuous deployment and automated synchronization of applications and infrastructure components.

## Core Principles

1. **All communications, code, and documentation MUST be in English**
2. **GitOps Approach**: All cluster changes are made through Git commits
3. **Declarative Configuration**: Infrastructure and applications are defined declaratively using YAML
4. **Automated Synchronization**: ArgoCD automatically syncs changes from the repository to the cluster

## Repository Structure

```
├── gitops/                 # Main GitOps configuration directory
│   ├── app/               # Application-level deployments
│   │   ├── metrics-server/
│   │   └── monitoring/
│   ├── infra/             # Infrastructure components
│   │   ├── cloudflare-tunnel/
│   │   ├── ingress-nginx/
│   │   ├── longhorn/
│   │   └── sealed-secrets/
│   └── bootstrap/         # Bootstrap configuration for ArgoCD
├── argocd/                # ArgoCD helm installation values
└── archive/               # Archived configurations (old Flux CD setup)
```

## Technology Stack

### Core Technologies
- **Kubernetes**: Container orchestration platform
- **ArgoCD**: GitOps continuous delivery tool
- **Helm**: Kubernetes package manager
- **Kustomize**: Kubernetes native configuration management

### Infrastructure Components
- **Ingress NGINX**: Kubernetes ingress controller
- **Sealed Secrets**: Encrypted secrets management
- **Longhorn**: Distributed block storage
- **Cloudflare Tunnel**: Secure external access
- **External DNS**: Automatic DNS management

### Monitoring & Observability
- **Prometheus Stack**: Metrics collection and alerting
- **Grafana**: Visualization and dashboards

## Working with ArgoCD Applications

### Application Structure

ArgoCD Applications follow this pattern:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <component-name>
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
  sources:
    - chart: <helm-chart-name>
      repoURL: <helm-repo-url>
      targetRevision: <version>
      helm:
        values: |
          # Helm values here
    - repoURL: https://github.com/jbwittner/k8s_deploy
      targetRevision: main
      path: gitops/<infra|app>/<component>/resources
  destination:
    server: https://kubernetes.default.svc
    namespace: <target-namespace>
```

### Key Conventions

1. **Naming**: Use prefixes `infra-` for infrastructure and `app-` for applications
2. **Automated Sync**: Enable automated synchronization with `prune` and `selfHeal`
3. **Multiple Sources**: Use multi-source when combining Helm charts with additional resources
4. **Namespace Creation**: Always include `CreateNamespace=true` in syncOptions

## Secret Management

### Sealed Secrets

Secrets are encrypted using Bitnami Sealed Secrets:

```bash
# Generate sealed secret
cat path/to/file.secret.yaml | kubeseal \
  --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > path/to/file.sealed-secret.yaml
```

**Important Naming Conventions**:
- Plain secret files MUST follow the pattern `*.secret.yaml`
- Sealed secret files MUST follow the pattern `*.sealed-secret.yaml`
- `*.secret.yaml` files are in `.gitignore` and CANNOT be committed to the repository
- Only `*.sealed-secret.yaml` files should be committed to version control

**Important**: Never commit plain Kubernetes secrets to the repository. Always use sealed secrets for sensitive data.

## Development Workflow

### Adding a New Application

1. Create directory structure: `gitops/app/<app-name>/`
2. Create ArgoCD Application manifest: `<app-name>.yaml`
3. Create resources directory if needed: `resources/`
4. Update `gitops/app/kustomization.yaml` to include the new application
5. Document the application in a `README.md`

### Adding Infrastructure Component

1. Create directory structure: `gitops/infra/<component-name>/`
2. Create ArgoCD Application manifest: `<component-name>.yaml`
3. Create resources directory if needed: `resources/`
4. Update `gitops/infra/kustomization.yaml` to include the component
5. Document the component in a `README.md`

### Making Changes

1. Modify YAML configurations in the appropriate directory
2. Test locally using `kubectl` or `kustomize build` if applicable
3. Commit changes with descriptive commit messages
4. ArgoCD will automatically detect and apply changes

## Kubernetes Best Practices

### Resource Management
- Always specify resource requests and limits
- Use appropriate storage classes (Longhorn for persistent volumes)
- Implement health checks (readiness and liveness probes)

### Networking
- Use Ingress resources for external access
- Configure appropriate annotations for Cloudflare Tunnel integration:
  ```yaml
  external-dns.alpha.kubernetes.io/cloudflare-proxied: "true"
  external-dns.alpha.kubernetes.io/hostname: <subdomain>.wittnerlab.com
  external-dns.alpha.kubernetes.io/target: <tunnel-id>.cfargotunnel.com
  ```

### Security
- Use NetworkPolicies where appropriate
- Implement RBAC with least privilege principle
- Store secrets using Sealed Secrets
- Enable TLS for all external endpoints

## Common Commands

### ArgoCD Bootstrap
```bash
# Bootstrap infrastructure applications
kubectl apply -f gitops/bootstrap/bootstrap-infra.yaml

# Bootstrap application layer
kubectl apply -f gitops/bootstrap/bootstrap-app.yaml
```

### ArgoCD Management
```bash
# Get admin password
kubectl get secret argocd-initial-admin-secret -n argocd \
  -o jsonpath='{.data.password}' | base64 -d

# Port-forward to ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Sealed Secrets
```bash
# Create and seal a secret
kubectl create secret generic <secret-name> \
  --from-literal=key=value \
  --dry-run=client -o yaml | \
  kubeseal --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > sealed-secret.yaml
```

### Kustomize
```bash
# Build and preview kustomization
kustomize build gitops/app

# Apply kustomization
kubectl apply -k gitops/app
```

## Troubleshooting Guidelines

### Application Sync Issues
1. Check ArgoCD application status: `kubectl get applications -n argocd`
2. Describe the application: `kubectl describe application <app-name> -n argocd`
3. Check ArgoCD logs: `kubectl logs -n argocd deployment/argocd-application-controller`

### Sealed Secrets Issues
1. Verify sealed-secrets controller is running
2. Check controller logs for decryption errors
3. Ensure the sealed secret was encrypted with the correct controller

### Storage Issues (Longhorn)
1. Check Longhorn dashboard at configured ingress
2. Verify node disk configuration
3. Review volume and replica status

## Code Style Guidelines

### YAML
- Use 2 spaces for indentation
- Keep line length under 120 characters
- Use meaningful and descriptive names
- Add comments for complex configurations
- Organize resources logically (namespace, secrets, deployments, services, ingress)

### Documentation
- **All documentation MUST be written in English**
- Every application/component should have a README.md
- Include purpose, dependencies, and configuration details
- Document any manual steps or special procedures
- Keep documentation up to date with changes

## Important Notes

1. **Language Requirement**: All content (code, comments, documentation, commit messages) MUST be written in English
2. **Archive Directory**: The `archive/` directory contains old Flux CD configurations - do not modify these
3. **Cluster Specific**: This configuration is tailored for a Talos Linux cluster on OVH infrastructure
4. **Domain**: External services use the `wittnerlab.com` domain
5. **Backup Key**: The `sealed-secret-key.yaml` at root is the backup encryption key - handle with extreme care

## AI Agent Guidelines

When working on this repository:
1. **All content (code comments, documentation, commit messages, README files) MUST be written in English**
2. Always verify the component type (app vs infra) before creating files
3. Follow the established naming conventions strictly
4. Update kustomization.yaml files when adding new resources
5. Create README.md files for new components (in English)
6. Use the correct ArgoCD project (infra-project or app-project)
7. Validate YAML syntax before committing
8. Consider dependencies between components
9. Respect the GitOps workflow - changes through Git only

## References

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Sealed Secrets](https://github.com/bitnami-labs/sealed-secrets)
- [Longhorn Documentation](https://longhorn.io/docs/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Helm Documentation](https://helm.sh/docs/)

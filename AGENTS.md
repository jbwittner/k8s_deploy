# GitHub Copilot Instructions for k8s_deploy

## Project Context
- **Architecture**: GitOps using ArgoCD with an "App of Apps" pattern.
- **Cluster**: Talos Linux on OVH.
- **Domain**: `wittnerlab.com`.
- **Language**: English ONLY for all code, comments, and documentation.

## Codebase Organization
- `gitops/bootstrap/`: Root "App of Apps" manifests (`bootstrap-app.yaml`, `bootstrap-infra.yaml`).
- `gitops/app/`: User-facing applications (e.g., monitoring, databases).
- `gitops/infra/`: System infrastructure (e.g., ingress, storage, secrets).
- `gitops/<type>/kustomization.yaml`: Aggregates ArgoCD Application manifests.
- `argocd/`: ArgoCD helm installation values.

## Development Workflow

### Adding a New Component (App or Infra)
1.  **Directory**: Create `gitops/<type>/<name>/`.
2.  **Application Manifest**: Create `gitops/<type>/<name>/<name>.yaml`.
    - **Kind**: `Application` (apiVersion: `argoproj.io/v1alpha1`).
    - **Namespace**: `argocd`.
    - **Project**: `default` (or specific project if defined).
    - **SyncPolicy**: Enable automated sync (`prune: true`, `selfHeal: true`) and `CreateNamespace=true`.
3.  **Resources**:
    - If Helm: Use `sources` (multi-source) to combine Chart + `resources/` directory.
    - If Plain YAML: Put manifests in `gitops/<type>/<name>/resources/`.
4.  **Registration**: Add `<name>/<name>.yaml` to `gitops/<type>/kustomization.yaml`.
5.  **Documentation**: Create `gitops/<type>/<name>/README.md`.

### Secret Management
- **Tool**: Bitnami Sealed Secrets.
- **Workflow**:
    1. Create `secret.yaml` (gitignored).
    2. Seal it: `kubeseal --controller-namespace sealed-secrets --controller-name infra-sealed-secrets --format yaml < secret.yaml > sealed-secret.yaml`.
    3. Commit ONLY `sealed-secret.yaml`.
- **Location**: Place `sealed-secret.yaml` in the component's `resources/` directory.

### Ignored Files
Ignore the files in `archive` folder.

## Critical Conventions

### Naming
- **Infrastructure Apps**: Prefix with `infra-` (e.g., `infra-longhorn`).
- **User Apps**: Prefix with `app-` (e.g., `app-monitoring`).
- **DNS**: `<subdomain>.wittnerlab.com`.

### Networking & Ingress
- **Controller**: Ingress NGINX.
- **External Access**: Cloudflare Tunnel.
- **Required Annotations**:
    ```yaml
    external-dns.alpha.kubernetes.io/cloudflare-proxied: "true"
    external-dns.alpha.kubernetes.io/hostname: <subdomain>.wittnerlab.com
    external-dns.alpha.kubernetes.io/target: <tunnel-id>.cfargotunnel.com
    ```

### Storage
- **Class**: `longhorn` (default for persistent storage).
- **Access Modes**: Typically `ReadWriteOnce`.

## Documentation Standard
Every component MUST have a `README.md` following the template located at `.github/COMPONENT_README_TEMPLATE.md`.

## ArgoCD Application Pattern
Use the **Multi-Source** pattern when using Helm charts to allow adding custom resources (like SealedSecrets) alongside the chart:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: <prefix>-<name>
  namespace: argocd
spec:
  sources:
    - chart: <chart-name>
      repoURL: <repo-url>
      targetRevision: <version>
      helm:
        values: |
          # ... values ...
    - repoURL: https://github.com/jbwittner/k8s_deploy
      targetRevision: main
      path: gitops/<type>/<name>/resources
```

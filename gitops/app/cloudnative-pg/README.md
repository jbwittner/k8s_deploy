# CloudNative-PG

CloudNative-PG is a Kubernetes operator that manages the full lifecycle of PostgreSQL database clusters with streaming replication and automated backups.

## Overview

This deployment consists of two components:

1. **Operator**: The CloudNative-PG operator managing PostgreSQL clusters lifecycle
2. **Cluster**: PostgreSQL cluster instances (currently commented out)

## Deployed Components

### CloudNative-PG Operator

- **Chart**: `cnpg` from CloudNative-PG Helm repository
- **Version**: `0.26.1`
- **Namespace**: `cnpg-system`
- **Sync Policy**: Automated with prune and self-heal enabled

The operator provides:
- High availability PostgreSQL clusters with streaming replication
- Automated backup and recovery
- Rolling updates and failover management
- Connection pooling with PgBouncer
- Monitoring and observability integration

### PostgreSQL Cluster (Optional)

- **Chart**: `cluster` from CloudNative-PG Helm repository
- **Version**: `0.3.1`
- **Namespace**: `databases`
- **Status**: Currently disabled (commented in kustomization.yaml)

## ArgoCD Applications

### Operator Application

Located in `operator/cloudnative-pg-operator.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-cloudnative-pg-operator
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
    - chart: cnpg
      repoURL: https://cloudnative-pg.github.io/charts
      targetRevision: 0.26.1
  destination:
    server: https://kubernetes.default.svc
    namespace: cnpg-system
```

### Cluster Application

Located in `cluster/cloudnative-pg-cluster.yaml`:

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: app-cloudnative-pg-cluster
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
    - chart: cluster
      repoURL: https://cloudnative-pg.github.io/charts
      targetRevision: 0.3.1
  destination:
    server: https://kubernetes.default.svc
    namespace: databases
```

## Verification

Check operator deployment:

```bash
# Check operator status
kubectl get pods -n cnpg-system

# View operator logs
kubectl logs -n cnpg-system -l app.kubernetes.io/name=cloudnative-pg

# List PostgreSQL clusters
kubectl get cluster -A
```

## Enabling the PostgreSQL Cluster

To deploy the PostgreSQL cluster, uncomment the line in `kustomization.yaml`:

```yaml
resources:
  - operator/cloudnative-pg-operator.yaml
  - cluster/cloudnative-pg-cluster.yaml  # Uncomment this line
```

## Creating Custom PostgreSQL Clusters

You can create custom PostgreSQL clusters using the CloudNative-PG CRD:

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: my-postgres
  namespace: databases
spec:
  instances: 3
  storage:
    size: 10Gi
    storageClass: longhorn
  postgresql:
    parameters:
      max_connections: "100"
      shared_buffers: "256MB"
  bootstrap:
    initdb:
      database: app
      owner: app
```

## References

- [CloudNative-PG Documentation](https://cloudnative-pg.io/documentation/)
- [CloudNative-PG GitHub](https://github.com/cloudnative-pg/cloudnative-pg)
- [Helm Chart Repository](https://cloudnative-pg.github.io/charts)

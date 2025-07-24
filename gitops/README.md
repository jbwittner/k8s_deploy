# GitOps Configuration

Ce dossier contient la configuration GitOps pour le cluster Kubernetes, utilisant Flux CD pour la gestion automatisée des déploiements.

## Structure

- `apps/` - Applications déployées sur le cluster
- `infrastructure/` - Composants d'infrastructure critique
- `cluster_talos_ovh/` - Configuration spécifique au cluster Talos sur OVH

## Politique des intervalles

Pour optimiser les performances du cluster et réduire la charge réseau, les intervalles de synchronisation sont configurés selon la politique suivante :

### HelmRepository (synchronisation des repositories)

#### Infrastructure critique (`1h0m`)
- **sealed-secrets** - Gestion des secrets chiffrés
- **ingress-nginx** - Contrôleur d'ingress
- **ceph-rook** - Stockage distribué
- **cloudflare-tunnel** - Tunnels sécurisés

#### Repositories officiels (`24h0m`)
- **prometheus-community** - Stack de monitoring
- **kubernetes-sigs** - Metrics server et external-dns
- **bitnami** - PostgreSQL, MinIO et autres charts officiels

#### Applications communautaires (`6h0m`)
- **excalidraw** - Outil de diagrammes
- **homepage** - Tableau de bord personnalisé
- **stirlingpdf** - Manipulation de fichiers PDF
- **privatebin** - Partage sécurisé de texte
- **github-actions** - Runners GitHub Actions

### HelmRelease (déploiement des applications)

#### Infrastructure critique (`5m0s` - `10m0s`)
- **sealed-secrets**, **ingress-nginx**, **cloudflare-tunnel** : `5m0s`
- **ceph-rook** (operator & cluster), **monitoring** : `10m0s`

#### Applications métier (`10m0s` - `15m0s`)
- **metrics-server**, **github-actions** : `10m0s`
- **Homepage**, **bases de données**, **applications utilitaires** : `15m0s`

Cette politique permet de réduire significativement la charge sur le cluster tout en maintenant une réactivité appropriée selon la criticité des composants.

## Commandes de réconciliation manuelle

Avec des intervalles plus longs, il peut être utile de forcer la réconciliation manuelle lors de changements urgents :

### Réconciliation complète du cluster
```bash
# Forcer la synchronisation de la source Git principale
flux reconcile source git flux-system

# Forcer toutes les Kustomizations du système
flux reconcile kustomization flux-system
```

### Réconciliation d'une Kustomization spécifique
```bash
# Infrastructure
flux reconcile kustomization infra-sealed-secrets
flux reconcile kustomization infra-ingress-nginx
flux reconcile kustomization infra-ceph-rook

# Applications
flux reconcile kustomization apps-monitoring
flux reconcile kustomization apps-excalidraw
flux reconcile kustomization apps-stirlingpdf
```

### Réconciliation d'un HelmRepository
```bash
# Forcer la mise à jour d'un repository Helm
flux reconcile source helm sealed-secrets-repository -n sealed-secrets
flux reconcile source helm monitoring-repository -n monitoring
flux reconcile source helm excalidraw-repository -n excalidraw
```

### Réconciliation d'un HelmRelease
```bash
# Forcer le redéploiement d'une application
flux reconcile helmrelease sealed-secrets-release -n sealed-secrets
flux reconcile helmrelease monitoring-release -n monitoring
flux reconcile helmrelease excalidraw-release -n excalidraw
```

### Réconciliation en cascade
```bash
# Forcer la réconciliation d'une source ET de ses dépendances
flux reconcile source git flux-system --with-source
flux reconcile kustomization infra-ingress-nginx --with-source
```

### Surveillance en temps réel
```bash
# Surveiller les événements Flux
flux events --watch

# Vérifier le statut global
flux get all

# Vérifier un namespace spécifique
flux get all -n monitoring
```

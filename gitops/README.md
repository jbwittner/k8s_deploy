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

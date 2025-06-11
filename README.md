# k8s_deploy

Ce répertoire contient les fichiers nécessaires pour déployer différents services sur un cluster Kubernetes.

## Prérequis

- Un cluster Kubernetes
- `kubectl` installé et configuré pour le cluster
- `helm` installé
- `kustomize` installé
- `flux cli` installé

## Installation de flux

J'utilise la partie GitHub => https://fluxcd.io/flux/installation/bootstrap/github/

il faut en premier exporter un PAT :

```bash	
export GITHUB_TOKEN=<gh-token>
```

```bash
flux bootstrap github \
  --token-auth \
  --owner=jbwittner \
  --repository=k8s_deploy \
  --branch=main \
  --path=gitops/cluster_talos_ovh \
  --private=false \
  --personal
```


## Deploiement

-> [Bankwiz](./bankwiz/README.md) <-
-> [Ingress Nginx](./nginx/README.md) <-

## Commandes utiles

```bash
flux get all
```

```bash
watch flux get all
```
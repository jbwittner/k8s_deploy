# Documentation

## Installation

```shell
helm repo add argo https://argoproj.github.io/argo-helm
```

```shell
helm install --values classic/argocd/values.yaml argocd argo/argo-cd --namespace argocd --create-namespace
``` 
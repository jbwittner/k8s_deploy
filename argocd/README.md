# Documentation

## Installation

```shell
helm repo add argo https://argoproj.github.io/argo-helm
```

```shell
helm search repo argo
```

```shell
helm install --values argocd/values.yaml argocd argo/argo-cd --namespace argocd --create-namespace
```

## Get default admin password

```shell
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d
```

## Accessing the Argo CD web UI

By default, the Argo CD API server is not exposed with an external IP. To access the Argo CD web UI, you can port-forward the service to your local machine:

```shell
kubectl port-forward svc/argocd-server -n argocd 8080:443
``` 

## Update the timout reconciliation


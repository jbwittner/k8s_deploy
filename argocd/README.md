# Documentation

## Installation

https://github.com/argoproj/argo-helm

```shell
helm repo add argo https://argoproj.github.io/argo-helm
```

```shell
helm search repo argo
```

```shell
helm install --values argocd/values.yaml argocd argo/argo-cd --namespace argocd --create-namespace
```

```shell
helm upgrade --values argocd/values.yaml argocd argo/argo-cd --namespace argocd
```

Pour permettre au tunnel Cloudflare d'accéder à Argo CD, il faut ajouter l'annotation suivante au service argocd-server:

```yaml
nginx.ingress.kubernetes.io/ssl-passthrough: "true" # Necessary for ArgoCD to work behind nginx with TLS
nginx.ingress.kubernetes.io/backend-protocol: "HTTPS" # Necessary for ArgoCD to work behind nginx with TLS
tls: true # Enable TLS termination
```

Mais dans un premier temps il faut initialiser sans et tester. Normalement on aura une erreur TOO_MANY_REDIRECTS.

Une fois obtenu il faut ajouter les annotations et relancer.

## Get default admin password

```shell
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath='{.data.password}' | base64 -d
```

## Accessing the Argo CD web UI

By default, the Argo CD API server is not exposed with an external IP. To access the Argo CD web UI, you can port-forward the service to your local machine:

```shell
kubectl port-forward svc/argocd-server -n argocd 8080:443
``` 

## Delete Argo CD

```shell
helm uninstall argocd -n argocd
```


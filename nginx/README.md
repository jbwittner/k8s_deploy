# Ingress Nginx

```
helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx -f ingress-nginx.yaml --namespace ingress-nginx --create-namespace
```
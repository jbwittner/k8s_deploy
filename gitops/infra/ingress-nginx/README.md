# Ingress NGINX

NGINX Ingress Controller for Kubernetes.

## Overview

Ingress NGINX is a Kubernetes ingress controller that uses NGINX as a reverse proxy and load balancer.

## Deployment

Deployed via ArgoCD using the official Helm chart:

```bash
kubectl get pods -n ingress-nginx
```

## Usage

Create an Ingress resource to expose a service:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  namespace: my-namespace
  annotations:
    # Add annotations as needed
spec:
  ingressClassName: nginx
  rules:
    - host: myapp.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-app
                port:
                  number: 80
```

## Cloudflare Integration

For services exposed via Cloudflare Tunnel, add these annotations:

```yaml
annotations:
  external-dns.alpha.kubernetes.io/cloudflare-proxied: "true"
  external-dns.alpha.kubernetes.io/hostname: myapp.wittnerlab.com
  external-dns.alpha.kubernetes.io/target: <tunnel-id>.cfargotunnel.com
```

## Reference

- [Ingress NGINX Documentation](https://kubernetes.github.io/ingress-nginx/)
- [Helm Chart](https://github.com/kubernetes/ingress-nginx/tree/main/charts/ingress-nginx)



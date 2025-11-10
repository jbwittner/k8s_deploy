# Cloudflare Tunnel

Secure external access to Kubernetes services via Cloudflare Tunnel.

## Overview

This configuration manages:
- **Cloudflare Tunnel** (`wittnerlab-com`): Secure tunnel to expose services
- **External DNS**: Automatic DNS record creation in Cloudflare

## Components

### Tunnel Configuration
Located in `wittnerlab-com/`:
- Cloudflare Tunnel connector
- Ingress routes configuration

### External DNS
Located in `extra-dns/`:
- Automatic DNS management
- Cloudflare API integration

## Sealed Secrets

Generate sealed secrets for sensitive credentials:

```bash
# External DNS secret
cat gitops/infra/cloudflare-tunnel/extra-dns/resources/extra-dns.secret.yaml | \
  kubeseal --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > gitops/infra/cloudflare-tunnel/extra-dns/resources/extra-dns.sealed-secret.yaml

# Cloudflare Tunnel secret
cat gitops/infra/cloudflare-tunnel/wittnerlab-com/resources/cloudflare-tunnel.secret.yaml | \
  kubeseal --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > gitops/infra/cloudflare-tunnel/wittnerlab-com/resources/cloudflare-tunnel.sealed-secret.yaml
```

## Exposing Services

To expose a service via Cloudflare Tunnel:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app
  namespace: my-namespace
  annotations:
    external-dns.alpha.kubernetes.io/cloudflare-proxied: "true"
    external-dns.alpha.kubernetes.io/hostname: myapp.wittnerlab.com
    external-dns.alpha.kubernetes.io/target: <tunnel-id>.cfargotunnel.com
spec:
  ingressClassName: nginx
  rules:
    - host: myapp.wittnerlab.com
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

External DNS will automatically create the DNS CNAME record in Cloudflare.

## Traffic Flow

```
Internet → Cloudflare → Tunnel → Ingress NGINX → Service → Pod
```

## Verification

```bash
# Check tunnel pod
kubectl get pods -n cloudflare-tunnel

# Check external-dns logs
kubectl logs -n external-dns -l app.kubernetes.io/name=external-dns

# Verify DNS records in Cloudflare dashboard
```

## References

- [Cloudflare Tunnel Helm Chart](https://github.com/cloudflare/helm-charts/tree/main/charts/cloudflare-tunnel)
- [External DNS Chart](https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns)
- [Integration Guide](https://itnext.io/exposing-kubernetes-apps-to-the-internet-with-cloudflare-tunnel-ingress-controller-and-e30307c0fcb0)
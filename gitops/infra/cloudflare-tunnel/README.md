# cloudflare-tunnel

## Génération du secret

```bash
cat gitops/infra/cloudflare-tunel/wittnerlab-com/cloudflare-tunnel.secret.yaml | kubeseal --controller-namespace sealed-secrets --controller-name infra-sealed-secrets --format yaml > gitops/infra/cloudflare-tunel/wittnerlab-com/cloudflare-tunnel.sealed-secret.yaml
```

## Informations sur le tunnel

Nom du tunnel : `wittnerlab-com`

Lien vers le chart Helm : https://github.com/cloudflare/helm-charts/tree/main/charts/cloudflare-tunnel

## Documentation

https://itnext.io/exposing-kubernetes-apps-to-the-internet-with-cloudflare-tunnel-ingress-controller-and-e30307c0fcb0

## external-dns

Lien vers le chart Helm : https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns
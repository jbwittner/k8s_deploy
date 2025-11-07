# cloudflare-tunnel

## Génération des secret

```bash
cat gitops/infra/cloudflare-tunnel/extra-dns/resources/extra-dns.secret.yaml | kubeseal --controller-namespace sealed-secrets --controller-name infra-sealed-secrets --format yaml > gitops/infra/cloudflare-tunnel/extra-dns/resources/extra-dns.sealed-secret.yaml
```

```bash
cat gitops/infra/cloudflare-tunnel/wittnerlab-com/resources/cloudflare-tunnel.secret.yaml | kubeseal --controller-namespace sealed-secrets --controller-name infra-sealed-secrets --format yaml > gitops/infra/cloudflare-tunnel/wittnerlab-com/resources/cloudflare-tunnel.sealed-secret.yaml
```

## Informations sur le tunnel

Nom du tunnel : `wittnerlab-com`

Lien vers le chart Helm : https://github.com/cloudflare/helm-charts/tree/main/charts/cloudflare-tunnel

## Documentation

https://itnext.io/exposing-kubernetes-apps-to-the-internet-with-cloudflare-tunnel-ingress-controller-and-e30307c0fcb0

## external-dns

Lien vers le chart Helm : https://github.com/kubernetes-sigs/external-dns/tree/master/charts/external-dns
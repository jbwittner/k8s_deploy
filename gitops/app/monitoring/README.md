# Monitoring

## Génération du secret

```bash
cat gitops/app/monitoring/monitoring.secret.yaml | kubeseal --controller-namespace sealed-secrets --controller-name infra-sealed-secrets --format yaml > gitops/app/monitoring/monitoring.sealed-secret.yaml
```


## Grafana

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

```bash
helm upgrade --install --namespace monitoring dashboard prometheus-community/kube-prometheus-stack --create-namespace
```

```bash
helm uninstall dashboard
```

## Quickwit

https://github.com/quickwit-oss/helm-charts/tree/main/charts/quickwit

```bash
helm repo add quickwit https://helm.quickwit.io
```

```bash
helm upgrade --install --namespace monitoring search quickwit/quickwit -f search.yaml --create-namespace
```

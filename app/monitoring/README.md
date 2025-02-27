# Monitoring

## Grafana

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

```bash
helm upgrade --install --namespace monitoring dashboard prometheus-community/kube-prometheus-stack -f dashboard.yaml --create-namespace
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
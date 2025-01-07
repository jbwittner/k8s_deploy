# Monitoring

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

```
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
```

```
helm upgrade --install --namespace monitoring monitoring prometheus-community/kube-prometheus-stack -f monitoring.yaml --create-namespace
```

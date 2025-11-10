# Monitoring Stack

Complete monitoring solution with Prometheus, Grafana, and Alertmanager.

## Overview

This deployment includes:
- **Prometheus**: Metrics collection and storage
- **Grafana**: Visualization and dashboards
- **Alertmanager**: Alert routing and management
- **Node Exporter**: Node metrics
- **Kube State Metrics**: Kubernetes object metrics

Deployed using the `kube-prometheus-stack` Helm chart.

## Sealed Secrets

Generate sealed secret for sensitive configuration:

```bash
cat gitops/app/monitoring/resources/monitoring.secret.yaml | \
  kubeseal --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > gitops/app/monitoring/resources/monitoring.sealed-secret.yaml
```

## Access Dashboards

### Grafana

```bash
# Port-forward (if no ingress configured)
kubectl port-forward -n monitoring svc/app-monitoring-grafana 3000:80

# Open http://localhost:3000
# Default credentials are in the sealed secret
```

### Prometheus

```bash
kubectl port-forward -n monitoring svc/app-monitoring-kube-prometheus-prometheus 9090:9090

# Open http://localhost:9090
```

### Alertmanager

```bash
kubectl port-forward -n monitoring svc/app-monitoring-kube-prometheus-alertmanager 9093:9093

# Open http://localhost:9093
```

## Verification

```bash
# Check all monitoring pods
kubectl get pods -n monitoring

# Check Prometheus targets
kubectl port-forward -n monitoring svc/app-monitoring-kube-prometheus-prometheus 9090:9090
# Visit http://localhost:9090/targets

# Check ServiceMonitors
kubectl get servicemonitors -n monitoring
```

## Custom Dashboards

Grafana includes pre-configured dashboards for:
- Kubernetes cluster overview
- Node metrics
- Pod resources
- Persistent volumes
- Network traffic

Additional dashboards can be imported from [Grafana.com](https://grafana.com/grafana/dashboards/).

## References

- [kube-prometheus-stack Chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

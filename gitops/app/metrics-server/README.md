# metrics-server

Lien vers le chart Helm : https://github.com/kubernetes-sigs/metrics-server/tree/master/charts/metrics-server

## Talos

https://docs.siderolabs.com/kubernetes-guides/monitoring-and-observability/deploy-metrics-server

Pour utiliser metrics-server avec Talos, il est nécessaire d'ajouter des composants :

```bash
kubectl apply -f https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

```bash
kubectl delete -f https://raw.githubusercontent.com/alex1989hu/kubelet-serving-cert-approver/main/deploy/standalone-install.yaml
kubectl delete -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

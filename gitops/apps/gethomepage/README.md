# homepage

https://gethomepage.dev/

https://github.com/jameswynn/helm-charts

https://github.com/homarr-labs/dashboard-icons

```bash
helm repo add jameswynn https://jameswynn.github.io/helm-charts
```

```bash
helm upgrade --install homepage jameswynn/homepage -f values.yaml -n homepage --create-namespace
```

Pour forcer le mise a jour du pod :

```bash
kubectl rollout restart deployment homepage -n homepage
```

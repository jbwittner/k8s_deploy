# homepage

https://gethomepage.dev/

```bash
helm repo add jameswynn https://jameswynn.github.io/helm-charts
helm upgrade --install homepage jameswynn/homepage -f values.yaml -n homepage --create-namespace
```

Pour forcer le mise a jour du pod :

```bash
kubectl rollout restart deployment homepage -n homepage
```
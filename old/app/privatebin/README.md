# Yopass

```
helm repo add privatebin https://privatebin.github.io/helm-chart
```

```
helm upgrade --install --namespace privatebin privatebin --values values.yaml privatebin/privatebin --create-namespace
```
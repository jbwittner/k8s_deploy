# Longhorn

```
helm repo add longhorn https://charts.longhorn.io
```

```
kubectl label namespace longhorn-system pod-security.kubernetes.io/enforce=privileged
```

```
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.8.0
```


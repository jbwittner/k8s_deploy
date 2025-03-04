# Longhorn

Pour utiliser Longhorn il ne faut pas oublier de labeliser le namespace `longhorn-system` avec `pod-security.kubernetes.io/enforce=privileged`.

De plus il faut pas gérer le namespace `longhorn-system` avec FluxCD.

```
helm repo add longhorn https://charts.longhorn.io
```

```
kubectl label namespace longhorn-system pod-security.kubernetes.io/enforce=privileged
```

```
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.8.0
```


# Longhorn

Pour utiliser Longhorn il ne faut pas oublier de labeliser le namespace `longhorn-system` avec `pod-security.kubernetes.io/enforce=privileged`.

```
helm repo add longhorn https://charts.longhorn.io
```

```
kubectl label namespace longhorn-system pod-security.kubernetes.io/enforce=privileged
```

```
helm install longhorn longhorn/longhorn --namespace longhorn-system --create-namespace --version 1.8.0
```

Il faut au moins une class en ReclaimPolicy Retain pour les volumes Longhorn.

# Utilisation avec flux

J'ai pu remarquer des soucis si je laisse flux gérer le namespace `longhorn-system` et les ressources qui s'y trouvent. Il faut donc le retirer de la gestion de flux.

Il faut donc ajouter à la main le namespace `longhorn-system` au cluster avec la commande suivante :

```
kubectl create namespace longhorn-system
```

Il faut aussi ajouter le label `pod-security.kubernetes.io/enforce=privileged` au namespace `longhorn-system` :

```
kubectl label namespace longhorn-system pod-security.kubernetes.io/enforce=privileged
```
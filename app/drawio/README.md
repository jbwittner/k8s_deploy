# Draw.io

https://hub.docker.com/r/jgraph/drawio

Il faut créer le namespece `draw-io` pour déployer les outils.

```bash
kubectl create namespace draw-io
```

Puis utiliser kustomize pour installer l'application

```bash
kubectl apply -k .
```
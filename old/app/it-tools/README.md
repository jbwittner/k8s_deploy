# it-tools

https://github.com/CorentinTh/it-tools

Il faut créer le namespece `it-tools` pour déployer les outils.

```bash
kubectl create namespace it-tools
```

Puis utiliser kustomize pour installer l'application

```bash
kubectl apply -k .
```
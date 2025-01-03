# Bankwiz

`Kustomize` est utisée pour la gestion des fichiers de configuration de l'application `bankwiz`.

## Commandes

Pour lancer un déploiement, il suffit de lancer la commande suivante:

```bash
kubectl apply -k dev
```

Pour update une image, sans changer les fichiers de configuration, il suffit de lancer la commande suivante (en remplaçant `sha1` par le sha1 de l'image):

```bash
kubectl set image deployment/bankwiz-deployment bankwiz-server-container=ghcr.io/jbwittner/bankwiz_server:develop-sha1 -n bankwiz-dev
```

L'update de l'image a pour effet de redémarrer les pods avec la nouvelle image.

## Secrets

il faut un fichier .env.TYPE_ENV.secret pour gérer des secrets (ces fichiers sont pas commitables).

Il suffit de copier le fichier .env.example.secret et de le renommer en .env.TYPE_ENV.secret. (TYPE_ENV = dev, prod, ...)
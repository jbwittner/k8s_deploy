# Minecraft Admin Pod

Ce pod Ubuntu permet d'accéder aux données des serveurs Minecraft pour l'administration et les sauvegardes.

## Fonctionnalités

- Accès en lecture/écriture aux PVC des serveurs Minecraft (ppz et nohu)
- Espace de stockage dédié pour les sauvegardes (5Gi)
- Outils préinstallés : nano, vim, rsync, zip, unzip, curl, wget, git
- Alias configurés pour navigation rapide

## Utilisation

### Démarrer le pod admin
```bash
kubectl scale deployment minecraft-admin -n minecraft --replicas=1
```

### Se connecter au pod
```bash
kubectl exec -it deployment/minecraft-admin -n minecraft -- /bin/bash
```

### Arrêter le pod admin (économie de ressources)
```bash
kubectl scale deployment minecraft-admin -n minecraft --replicas=0
```

## Structure des données montées

- `/minecraft-data/ppz/` - Données du serveur PPZ
- `/minecraft-data/nohu/` - Données du serveur NOHU  
- `/backups/` - Espace de stockage pour les sauvegardes

## Alias disponibles

- `ppz` - Aller dans le dossier des données PPZ
- `nohu` - Aller dans le dossier des données NOHU
- `backup` - Aller dans le dossier de sauvegarde
- `ll` - Listing détaillé des fichiers

## Exemple de sauvegarde

### Sauvegarde manuelle simple
```bash
# Se connecter au pod
kubectl exec -it deployment/minecraft-admin -n minecraft -- /bin/bash

# Créer une sauvegarde
cd /backups
zip -r "minecraft-ppz-$(date +%Y%m%d_%H%M%S).zip" /minecraft-data/ppz/
zip -r "minecraft-nohu-$(date +%Y%m%d_%H%M%S).zip" /minecraft-data/nohu/
```

### Sauvegarde automatique avec le script
```bash
# Utiliser le script de gestion (depuis l'host)
./minecraft-admin.sh backup

# Ou utiliser le script avancé (depuis le pod)
kubectl exec deployment/minecraft-admin -n minecraft -- /backup-script.sh
```

## Scripts utilitaires

- `minecraft-admin.sh` - Script de gestion du pod (start/stop/connect/backup/status)
- `backup-script.sh` - Script de sauvegarde avancé avec nettoyage automatique

# Minecraft Admin Pod

Ce pod Ubuntu permet d'accéder aux données des serveurs Minecraft pour l'administration et les sauvegardes.

## Fonctionnalités

- Pod toujours en fonctionnement (replicas=1)
- Accès en lecture/écriture aux PVC des serveurs Minecraft (ppz et nohu)
- Espace de stockage dédié pour les sauvegardes (5Gi)
- Serveur SSH intégré pour accès via port-forward
- Outils préinstallés : nano, vim, rsync, zip, unzip, curl, wget, git, openssh-server
- Alias configurés pour navigation rapide

## Utilisation

### Accès via port-forward et SSH
```bash
# Port-forward du service SSH
kubectl port-forward svc/minecraft-admin -n minecraft 2222:22

# Connexion SSH (mot de passe: minecraft123)
ssh root@localhost -p 2222
```

### Accès direct via kubectl exec
```bash
kubectl exec -it deployment/minecraft-admin -n minecraft -- /bin/bash
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
# Utiliser le script de gestion
./minecraft-admin.sh backup

# Ou utiliser le script avancé directement
kubectl exec deployment/minecraft-admin -n minecraft -- /backup-script.sh
```

## Scripts utilitaires

- `minecraft-admin.sh` - Script de gestion du pod (connect/ssh/port-forward/backup/status/restart)
- `backup-script.sh` - Script de sauvegarde avancé avec nettoyage automatique

## Exemples d'utilisation

### Connexion rapide
```bash
# Méthode 1: Connexion directe (plus rapide)
./minecraft-admin.sh connect

# Méthode 2: Via SSH avec port-forward
./minecraft-admin.sh port-forward
# Dans un autre terminal: ssh root@localhost -p 2222
```

### Gestion de fichiers via SSH/SCP
```bash
# Port-forward (dans un terminal)
kubectl port-forward svc/minecraft-admin -n minecraft 2222:22

# Upload de fichiers (dans un autre terminal)
scp -P 2222 fichier.txt root@localhost:/minecraft-data/ppz/

# Download de sauvegardes
scp -P 2222 root@localhost:/backups/*.zip ./
```

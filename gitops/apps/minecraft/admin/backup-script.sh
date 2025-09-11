#!/bin/bash

# Script de sauvegarde avancé pour les serveurs Minecraft
# À exécuter depuis l'intérieur du pod admin

BACKUP_DIR="/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DATE_FOLDER=$(date +%Y-%m)

# Créer le dossier du mois si nécessaire
mkdir -p "$BACKUP_DIR/$DATE_FOLDER"

echo "🎮 Démarrage de la sauvegarde Minecraft - $TIMESTAMP"
echo "📁 Dossier de destination: $BACKUP_DIR/$DATE_FOLDER"

# Fonction de sauvegarde avec compression et vérification
backup_server() {
    local server_name=$1
    local source_path=$2
    local backup_file="$BACKUP_DIR/$DATE_FOLDER/minecraft-${server_name}-${TIMESTAMP}.zip"
    
    echo "💾 Sauvegarde du serveur $server_name..."
    
    # Vérifier que le dossier source existe
    if [ ! -d "$source_path" ]; then
        echo "❌ Erreur: Le dossier $source_path n'existe pas!"
        return 1
    fi
    
    # Créer l'archive
    if zip -r "$backup_file" "$source_path" > /dev/null 2>&1; then
        # Vérifier la taille et l'intégrité
        local file_size=$(du -h "$backup_file" | cut -f1)
        echo "✅ $server_name sauvegardé ($file_size) -> $(basename "$backup_file")"
        
        # Test d'intégrité de l'archive
        if unzip -t "$backup_file" > /dev/null 2>&1; then
            echo "🔍 Archive $server_name vérifiée avec succès"
        else
            echo "⚠️  Attention: L'archive $server_name pourrait être corrompue"
        fi
    else
        echo "❌ Erreur lors de la sauvegarde de $server_name"
        return 1
    fi
}

# Sauvegarder les serveurs
backup_server "ppz" "/minecraft-data/ppz"
backup_server "nohu" "/minecraft-data/nohu"

# Résumé des sauvegardes
echo ""
echo "📊 Résumé des sauvegardes créées:"
ls -lh "$BACKUP_DIR/$DATE_FOLDER/minecraft-*-${TIMESTAMP}.zip" 2>/dev/null || echo "Aucune sauvegarde trouvée"

# Nettoyage automatique des anciennes sauvegardes (garde les 30 derniers jours)
echo ""
echo "🧹 Nettoyage des anciennes sauvegardes (>30 jours)..."
find "$BACKUP_DIR" -name "minecraft-*.zip" -type f -mtime +30 -delete
deleted_count=$(find "$BACKUP_DIR" -name "minecraft-*.zip" -type f -mtime +30 | wc -l)
echo "🗑️  $deleted_count ancienne(s) sauvegarde(s) supprimée(s)"

# Afficher l'espace disque utilisé
echo ""
echo "💽 Utilisation de l'espace de sauvegarde:"
du -sh "$BACKUP_DIR"

echo ""
echo "✅ Sauvegarde terminée - $TIMESTAMP"

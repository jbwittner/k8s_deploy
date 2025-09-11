#!/bin/bash

# Script de gestion du pod admin Minecraft
# Usage: ./minecraft-admin.sh [start|stop|connect|backup|status]

NAMESPACE="minecraft"
DEPLOYMENT="minecraft-admin"

case "$1" in
    start)
        echo "🚀 Démarrage du pod admin Minecraft..."
        kubectl scale deployment $DEPLOYMENT -n $NAMESPACE --replicas=1
        echo "⏳ Attente que le pod soit prêt..."
        kubectl wait --for=condition=available --timeout=300s deployment/$DEPLOYMENT -n $NAMESPACE
        echo "✅ Pod admin démarré avec succès!"
        ;;
        
    stop)
        echo "🛑 Arrêt du pod admin Minecraft..."
        kubectl scale deployment $DEPLOYMENT -n $NAMESPACE --replicas=0
        echo "✅ Pod admin arrêté!"
        ;;
        
    connect)
        echo "🔗 Connexion au pod admin..."
        kubectl exec -it deployment/$DEPLOYMENT -n $NAMESPACE -- /bin/bash
        ;;
        
    backup)
        echo "💾 Création d'une sauvegarde automatique..."
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        kubectl exec deployment/$DEPLOYMENT -n $NAMESPACE -- /bin/bash -c "
            cd /backups
            echo 'Sauvegarde du serveur PPZ...'
            zip -r minecraft-ppz-$TIMESTAMP.zip /minecraft-data/ppz/ > /dev/null 2>&1
            echo 'Sauvegarde du serveur NOHU...'
            zip -r minecraft-nohu-$TIMESTAMP.zip /minecraft-data/nohu/ > /dev/null 2>&1
            echo 'Sauvegardes créées:'
            ls -lh minecraft-*-$TIMESTAMP.zip
        "
        echo "✅ Sauvegardes créées avec succès!"
        ;;
        
    status)
        echo "📊 Status du pod admin:"
        kubectl get deployment $DEPLOYMENT -n $NAMESPACE
        echo ""
        echo "📊 Status des pods:"
        kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT
        ;;
        
    *)
        echo "Usage: $0 {start|stop|connect|backup|status}"
        echo ""
        echo "Commandes disponibles:"
        echo "  start   - Démarre le pod admin (replicas=1)"
        echo "  stop    - Arrête le pod admin (replicas=0)"
        echo "  connect - Se connecte au pod admin en mode interactif"
        echo "  backup  - Crée une sauvegarde automatique des données"
        echo "  status  - Affiche le status du pod admin"
        exit 1
        ;;
esac

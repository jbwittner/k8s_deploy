#!/bin/bash

# Script de gestion du pod admin Minecraft
# Usage: ./minecraft-admin.sh [connect|ssh|backup|status|restart]

NAMESPACE="minecraft"
DEPLOYMENT="minecraft-admin"

case "$1" in
    connect)
        echo "� Connexion directe au pod admin..."
        kubectl exec -it deployment/$DEPLOYMENT -n $NAMESPACE -- /bin/bash
        ;;
        
    ssh)
        echo "🔗 Connexion SSH via port-forward..."
        echo "⚠️  Vous devez d'abord ouvrir le port-forward dans un autre terminal:"
        echo "kubectl port-forward svc/$DEPLOYMENT -n $NAMESPACE 2222:22"
        echo ""
        echo "Puis connectez-vous avec: ssh root@localhost -p 2222"
        echo "Mot de passe: minecraft123"
        ;;
        
    port-forward)
        echo "� Démarrage du port-forward SSH..."
        echo "Connexion disponible avec: ssh root@localhost -p 2222 (mot de passe: minecraft123)"
        kubectl port-forward svc/$DEPLOYMENT -n $NAMESPACE 2222:22
        ;;
        
    backup)
        echo "💾 Création d'une sauvegarde automatique..."
        TIMESTAMP=$(date +%Y%m%d_%H%M%S)
        kubectl exec deployment/$DEPLOYMENT -n $NAMESPACE -- /backup-script.sh
        echo "✅ Sauvegarde terminée!"
        ;;
        
    status)
        echo "📊 Status du pod admin:"
        kubectl get deployment $DEPLOYMENT -n $NAMESPACE
        echo ""
        echo "📊 Status des pods:"
        kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT
        echo ""
        echo "📊 Status du service:"
        kubectl get svc $DEPLOYMENT -n $NAMESPACE
        ;;
        
    restart)
        echo "� Redémarrage du pod admin..."
        kubectl rollout restart deployment/$DEPLOYMENT -n $NAMESPACE
        kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE
        echo "✅ Pod redémarré!"
        ;;
        
    *)
        echo "Usage: $0 {connect|ssh|port-forward|backup|status|restart}"
        echo ""
        echo "Commandes disponibles:"
        echo "  connect      - Se connecte au pod admin via kubectl exec"
        echo "  ssh          - Affiche les instructions pour la connexion SSH"
        echo "  port-forward - Lance le port-forward pour SSH (2222:22)"
        echo "  backup       - Crée une sauvegarde automatique des données"
        echo "  status       - Affiche le status du pod admin"
        echo "  restart      - Redémarre le pod admin"
        exit 1
        ;;
esac

# Récupération token pour le service account

Il faut en premier lancer le kustomize :

```bash
kubectl apply -f -
```

Il faut attendre quelques secondes pui récupérer le token :

```bash
TOKEN=$(kubectl get secret deployment-updater-token -n bankwiz-dev -o jsonpath='{.data.token}' | base64 --decode)
```

Crée un fichier `deployment-updater.kubeconfig` avec les informations nécessaires

```yaml	
CLUSTER_NAME=$(kubectl config view --minify -o jsonpath='{.clusters[0].name}')
SERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')

cat <<EOF > deployment-updater.kubeconfig
apiVersion: v1
kind: Config
clusters:
- name: $CLUSTER_NAME
  cluster:
    server: $SERVER
    certificate-authority-data: $(kubectl config view --raw --minify -o jsonpath='{.clusters[0].cluster.certificate-authority-data}')
contexts:
- name: deployment-updater-context
  context:
    cluster: $CLUSTER_NAME
    user: deployment-updater
    namespace: default
current-context: deployment-updater-context
users:
- name: deployment-updater
  user:
    token: $TOKEN
EOF
```

pour tester la configuration :

```bash
KUBECONFIG=deployment-updater.kubeconfig kubectl set image deployment/bankwiz-deployment bankwiz-server-container=ghcr.io/jbwittner/bankwiz_server:TAG-IMG -n bankwiz-dev
```

```bash
KUBECONFIG=deployment-updater.kubeconfig kubectl set image deployment/bankwiz-deployment bankwiz-server-container=ghcr.io/jbwittner/bankwiz_server:develop-f1057e4ee24d80137154dad076b312437410dc39 -n bankwiz-dev
```
https://une-tasse-de.cafe/blog/sealed-secrets/

Le fichier généré pourra être importé dans un cluster via la commande kubectl.

```
kubectl apply -n kube-system -f sealed-secret-key.yaml
```


Pour générer un secret scellé, il faut d'abord créer un secret Kubernetes normal, puis le convertir en secret scellé avec la commande suivante :

```bash
cat secret.yaml | kubeseal --controller-namespace sealed-secrets --controller-name sealed-secrets-release --format yaml > sealed-secret.yaml
```

```bash
echo -n 'mega_secret_key' | openssl base64
```
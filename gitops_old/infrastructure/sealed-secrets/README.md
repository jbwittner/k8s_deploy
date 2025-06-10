https://une-tasse-de.cafe/blog/sealed-secrets/

Le fichier généré pourra être importé dans un cluster via la commande kubectl.

```
kubectl apply -n kube-system -f sealed-secret-key.yaml
```

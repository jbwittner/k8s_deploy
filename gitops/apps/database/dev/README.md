## Postgres

L'application a besoin de Postgres pour fonctionner. Pour déployer Postgres, il suffit de lancer la commande suivante:

```bash
helm upgrade --install db-dev oci://registry-1.docker.io/bitnamicharts/postgresql -f values.yaml -n db-dev --create-namespace
```

pour accéder à la bdd depuis le cluster il faut utiliser l'adresse suivante:

```bash
db-dev-postgresql.db-dev.svc.cluster.local
```

via le port 5432.
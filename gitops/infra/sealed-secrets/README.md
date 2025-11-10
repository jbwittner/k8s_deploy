# Sealed Secrets

Bitnami Sealed Secrets controller for encrypting Kubernetes secrets.

## Overview

Sealed Secrets allows you to store encrypted secrets in Git. The controller decrypts them in the cluster.

## Creating Sealed Secrets

### 1. Create a plain Kubernetes secret

```bash
kubectl create secret generic my-secret \
  --from-literal=username=admin \
  --from-literal=password=supersecret \
  --dry-run=client -o yaml > my-secret.secret.yaml
```

### 2. Seal the secret

```bash
cat my-secret.secret.yaml | kubeseal \
  --controller-namespace sealed-secrets \
  --controller-name infra-sealed-secrets \
  --format yaml > my-secret.sealed-secret.yaml
```

### 3. Commit only the sealed secret

```bash
git add my-secret.sealed-secret.yaml
# Never commit *.secret.yaml files (they are gitignored)
```

## Encoding Values

If you need to encode values manually:

```bash
echo -n 'my_secret_value' | base64
```

## Backup Encryption Key

The encryption key is critical for decrypting sealed secrets:

```bash
kubectl get secret -n sealed-secrets \
  -l sealedsecrets.bitnami.com/sealed-secrets-key=active \
  -o yaml > sealed-secret-key.yaml
```

**Important**: Store this backup securely. Without it, you cannot decrypt sealed secrets.

## Restore Encryption Key

```bash
kubectl apply -f sealed-secret-key.yaml -n sealed-secrets
kubectl delete pod -n sealed-secrets -l app.kubernetes.io/name=sealed-secrets
```

## Verification

```bash
# Check controller is running
kubectl get pods -n sealed-secrets

# View sealed secrets
kubectl get sealedsecrets -A

# Check if secret was decrypted
kubectl get secret <secret-name> -n <namespace>
```

## Reference

- [Sealed Secrets Documentation](https://github.com/bitnami-labs/sealed-secrets)
- [Tutorial (French)](https://une-tasse-de.cafe/blog/sealed-secrets/)
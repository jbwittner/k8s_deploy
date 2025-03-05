
```
cat mysecret.yaml | kubeseal \
    --controller-namespace kube-system \
    --controller-name sealed-secrets-release \
    --format yaml \
    > sealed-secret.yaml
```

```
kubeseal --fetch-cert --controller-namespace kube-system --controller-name sealed-secrets-release > cert.pem
```
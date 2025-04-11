# Monitoring

```shell
kubectl -n kube-dashboard port-forward svc/kube-dashboard-release-kong-proxy 8443:443
```

Il faut ajouter un user pour accéder au dashboard. => https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md

```shell
kubectl -n kube-dashboard create token admin-user
```
# Operator
helm upgrade --create-namespace --namespace rook-ceph rook-ceph rook-release/rook-ceph -f rook-ceph-operator-values.yaml

# Ceph Cluster
helm upgrade --create-namespace --namespace rook-ceph rook-ceph-cluster --set operatorNamespace=rook-ceph rook-release/rook-ceph-cluster -f rook-ceph-cluster-values.yaml


https://rook.io/docs/rook/latest/Storage-Configuration/Monitoring/ceph-monitoring/#prometheus-instances
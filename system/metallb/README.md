# MetalLB 

https://www.youtube.com/watch?v=LMOYOtzpoXg

https://metallb.universe.tf/installation/#installation-by-manifest

```bash
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.9/config/manifests/metallb-native.yaml
```

```bash
kubectl create -f ipaddresspool.yaml
```

```bash
kubectl create -f l2advertisement.yaml
```
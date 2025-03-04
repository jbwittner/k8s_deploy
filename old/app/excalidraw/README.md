# Excalidraw

```bash
helm repo add my-excalidraw https://pmoscode-helm.github.io/excalidraw/
```

```bash
helm upgrade --install excalidraw  my-excalidraw/excalidraw -f values.yaml -n excalidraw  --create-namespace
```
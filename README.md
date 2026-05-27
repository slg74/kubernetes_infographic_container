# Kubernetes Infographics

![Kubernetes Infographics](k8s1.png)

Visual reference guides for core Kubernetes concepts, served as static HTML pages from an nginx container running in a local Kubernetes cluster.

## Infographics

| File | Topic | Covers |
|------|-------|--------|
| [k8s-interfaces-cni-cri-csi.html](k8s-interfaces-cni-cri-csi.html) | **CNI · CRI · CSI** | The three plugin interfaces that make Kubernetes extensible — Container Network Interface, Container Runtime Interface, Container Storage Interface |
| [k8s-orchestration.html](k8s-orchestration.html) | **Orchestration** | Control plane components (API server, etcd, scheduler, controller-manager), worker node components, pod scheduling flow, reconciliation loop, and workload resource types |
| [k8s-networking.html](k8s-networking.html) | **Networking** | Pod networking model, Service types (ClusterIP/NodePort/LoadBalancer/Headless), Ingress, CoreDNS, NetworkPolicy, and kube-proxy modes |

## Project structure

```
.
├── Dockerfile                    # nginx:alpine image with all HTML files baked in
├── k8s-deploy.yaml               # Kubernetes Deployment + LoadBalancer Service
├── index.html                    # Landing page linking to all three infographics
├── k8s-interfaces-cni-cri-csi.html
├── k8s-orchestration.html
└── k8s-networking.html
```

## Prerequisites

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) with **Kubernetes enabled**
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/)
- [`kind`](https://kind.sigs.k8s.io/) CLI

> **Note:** Docker Desktop's built-in Kubernetes runs as a kind cluster (`desktop-control-plane`). The kubectl context is named `docker-desktop`.

## Deploy

### 1. Build the image

```bash
docker build -t k8s-infographics:latest .
```

### 2. Load it into the cluster

Docker Desktop Kubernetes uses kind under the hood. Images must be loaded directly into the kind node's containerd store — they are **not** automatically available from the Docker daemon.

```bash
kind load docker-image k8s-infographics:latest --name desktop
```

### 3. Apply the manifests

```bash
kubectl --context docker-desktop apply -f k8s-deploy.yaml
```

### 4. Wait for pods to be ready

```bash
kubectl --context docker-desktop rollout status deployment/k8s-infographics
```

### 5. Forward a local port

The cluster's LoadBalancer IP isn't assigned by default (the Envoy-based cloud provider requires additional setup), so use `port-forward` to reach the service:

```bash
kubectl --context docker-desktop port-forward service/k8s-infographics 8080:80
```

Open **http://localhost:8080** in your browser.

## Updating the infographics

After editing any `.html` file, rebuild and re-roll the deployment:

```bash
docker build -t k8s-infographics:latest .
kind load docker-image k8s-infographics:latest --name desktop
kubectl --context docker-desktop rollout restart deployment/k8s-infographics
```

## Tear down

```bash
kubectl --context docker-desktop delete -f k8s-deploy.yaml
```

## Why `imagePullPolicy: Never`?

The manifest sets `imagePullPolicy: Never` because the image is loaded directly into the kind node rather than pushed to a registry. If you push the image to a registry (Docker Hub, GHCR, etc.) and update the `image:` field accordingly, change this to `IfNotPresent`.

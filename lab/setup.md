# Setup

## Get dev tools for your local machine

```bash
# Get Arkade
curl -sLS https://get.arkade.dev | sudo sh
# Get tools needed for thee lab
ark get helm
ark get k3d
ark get kubectx
# Temporarily make them available in your path
export PATH=$PATH:$HOME/.arkade/bin/
```

## Create a Kubernetes cluster and install supporting software in the cluster

```bash
# Capture your current Kubernetes context
export CURRENT_CONTEXT=$(kubectx)
# k3s set up a cluster in docker containers!
k3d cluster create
# switch your current context to the k3d cluster
kubectx k3d-k3s-default
# Setup helm repos to get software for your Kubernetes cluster
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
# Install Prometheus, later it'll scrape metrics from the Python app's pods
helm upgrade --install metrics prometheus-community/prometheus
# Install Loki-stack, this can be used to easily look at logs
helm upgrade --install logging grafana/loki-stack \
  --namespace default --set promtail.enabled=true \
  --set grafana.enabled=true 
```

## Build and push a container image to Docker Hub

Prior to running the script below, make sure you've altered it to point at your own account on Docker Hub. [Refer to the instructions here for detail.](https://github.com/kylos101/python-with-prometheus#instructions)

**Note**: If you decide to alter the Python app (hurray!), you'll find yourself running this script often to publish new images and test them on your Kubernetes cluster.

```bash
# this will build an image, tag it, and push it to the Docker Hub for you
./scripts/image-build.sh
```

## Add the Python app to your Kubernetes cluster

```bash
# Allow the app's pods to use the Kubernetes API to list pods
# The code for the `running_pods` metric depends on this
kubectl apply -f ./k8s_resources/rbac.yaml
# Deploy pods which rely on the Docker image in your Docker Hub account's repo
kubectl apply -f ./k8s_resources/deployment.yaml
# Setup a related service for the deployment
kubectl apply -f ./k8s_resources/service.yaml
```

## Test

[Good job! You are now ready to test.](./testing.md)

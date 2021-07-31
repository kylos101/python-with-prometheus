#
# Local machine setup

# Get arkade
curl -sLS https://get.arkade.dev | sudo sh

# Get and setup tools
ark get helm
ark get k3d
ark get kubectx
sudo mv /home/kylos/.arkade/bin/helm /usr/local/bin/
sudo mv /home/kylos/.arkade/bin/k3d /usr/local/bin/
sudo mv /home/kylos/.arkade/bin/kubectx /usr/local/bin/

#
# Test cluster setup
k3d cluster create
kubectx k3d-k3s-default

#
# Install support software for the app
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Install Prometheus to the cluster
helm install metrics prometheus-community/prometheus

# Install Loki-stack to the cluster
helm upgrade --install loki-stack grafana/loki-stack --namespace default --set promtail.enabled=true \
  --set grafana.enabled=true 

#
# App setup

# Build and push the image
./scripts/image-build.sh # make sure you've pointed at your own Docker Repo...

# Allow pods to use the Kubernetes API to list pods
kubectl apply -f ./k8s_resources/rbac.yaml

# Deploy pods which rely on the prior image
kubectl apply -f ./k8s_resources/deployment.yaml

# Setup a related service for the deployment
kubectl apply -f ./k8s_resources/service.yaml

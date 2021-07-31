k3d cluster create
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# METRICS
helm install metrics prometheus-community/prometheus

# LOGGING
helm upgrade --install loki-stack grafana/loki-stack --namespace default --set promtail.enabled=true \
  --set grafana.enabled=true 

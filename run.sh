# build our image
docker build -t python-and-prometheus .

# Uncomment me to test the image locally
docker run -p 8080:5000 -it --rm --name slytherin-slimes python-and-prometheus

# Prepare and push to a Docker Registry
# docker tag python-and-prometheus kylos101/python-with-prometheus:0.0.1
# docker push kylos101/python-with-prometheus:0.0.1

# publish our image (so the cluster can pull it later)

# k3d cluster create
# helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
# helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
# helm repo add grafana https://grafana.github.io/helm-charts
# helm repo update
# helm install metrics prometheus-community/prometheus
# helm install visualize grafana/grafana
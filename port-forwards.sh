kubectl port-forward svc/metrics-prometheus-server 8082:80 &
kubectl port-forward svc/slytherin-svc 5000:5000
kubectl port-forward svc/slytherin-svc 8090:8090
kubectl port-forward service/loki-stack-grafana 3000:80 &

# Logging password
GRAFANA=$(kubectl get secret loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
echo $GRAFANA
# Prometheus UI
# ...show the metrics
# http://localhost:8082/graph?g0.expr=kubelet_running_pods&g0.tab=1&g0.stacked=0&g0.range_input=1h&g1.expr=running_pods&g1.tab=1&g1.stacked=0&g1.range_input=1h&g2.expr=app_hello_world_total&g2.tab=0&g2.stacked=0&g2.range_input=1h
kubectl port-forward svc/metrics-prometheus-server 8082:80 &

# Inspect http://localhost:5000/metrics or call the API listening on http://localhost:5000
kubectl port-forward svc/slytherin-svc 5000:5000

# For debuggin'
kubectl port-forward service/loki-stack-grafana 3000:80 &
GRAFANA=$(kubectl get secret loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
echo $GRAFANA
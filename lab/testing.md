# Metrics in this lab

## Overview of each metric

1. `running_pods` is a [Gauge metric](https://github.com/prometheus/client_python#gauge), and shows the total # of running pods in Kubernetes. [It is started here in a separate thread](https://github.com/kylos101/python-with-prometheus/blob/877e9cdf5d977cd6f5f955df1a6f62dd8d286f7b/app/app.py#L49), leverages a Python library to interrogate the Kubernetes API, and then filters by Status to return a count of running pods in your Kubernetes cluster.
2. `app_hello_world` is a [Counter metric](https://github.com/prometheus/client_python#counter), and increments each time the `https://localhost:5000` endpoint is hit. [It's value is incremented here.](https://github.com/kylos101/python-with-prometheus/blob/877e9cdf5d977cd6f5f955df1a6f62dd8d286f7b/app/app.py#L19)

You can [experiment with other metrics using the same Python library](https://github.com/prometheus/client_python#instrumenting), if you like.

## Test each metric

First, we have to make it possible to view the Prometheus server's UI.

Run this command:

```bash
# Port forward to the Prometheus UI
kubectl port-forward svc/metrics-prometheus-server 8082:80 &
```

[View both metrics in Prometheus](http://localhost:8082/graph?g0.expr=kubelet_running_pods&g0.tab=1&g0.stacked=0&g0.range_input=1h&g1.expr=running_pods&g1.tab=1&g1.stacked=0&g1.range_input=1h&g2.expr=app_hello_world_total&g2.tab=0&g2.stacked=0&g2.range_input=1h). Follow the instructions below to inspect and test each metric.

### The `running_pods` metric

Assuming you opened the Prometheus server's UI (above), you should see that both metrics have the same value.

`kubelet_running_pods` is a built-in metric that you get out-of-the-box with Prometheus. It should have the same value as our custom `running_pods` metric.

Scale the Python app to go up by one:

```bash
kubectl scale deployment python-with-prometheus --replicas=2
```

Inspect `running_pods` and `kubelet_running_pods` to see the change in Prometheus.

### The `app_hello_world` metric

First, we have to make it possible to call the Python app.

Run this command:

```bash
# Port forward to the Python app
kubectl port-forward svc/slytherin-svc 5000:5000 &
```

Then, call the Python app's API however many times you like using `curl`:

```bash
# This will call our API and return "Hello, World!"
curl http://localhost:5000
```

Assuming you opened the Prometheus server's UI (above), you should see the count for `app_hello_world_total` go up however many times you called the API.

## How does Prometheus get the metric data for these counters?

Prometheus reads [text based metrics](https://prometheus.io/docs/instrumenting/exposition_formats/).

The text it actually ingests for this lab can be [viewed here, assuming you still have the port-forward setup on port 5000](http://localhost:5000/metrics). For background, the app is setup [serve Prometheus metrics here](https://github.com/kylos101/python-with-prometheus/blob/877e9cdf5d977cd6f5f955df1a6f62dd8d286f7b/app/app.py#L51).

Prometheus is installed with a Helm chart in this lab, and the chart supports annotations. Essentially, Prometheus will watch for pods that have these annotations, configure itself to use them, and then ingest their metrics.

## View logs

First, we have to get access to loki-stack:

```bash
# make it accessible
kubectl port-forward service/loki-stack-grafana 3000:80 &
# export its admin password
GRAFANA=$(kubectl get secret loki-stack-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)
# copy this password
echo $GRAFANA
```

Then, you can [view logs for the Python app here](http://localhost:3000/explore?orgId=1&left=%5B%22now-5m%22,%22now%22,%22Loki%22,%7B%22expr%22:%22%7Bapp%3D%5C%22python-with-prometheus%5C%22%7D%22%7D%5D), after logging in of course.

## Clean-up

```bash
# delete the Kubernetes cluster
k3d cluster delete
# point back at your original kubernetes context
kubectx $CURRENT_CONTEXT
# close the terminal
exit
```

No local machines were (hopefully) harmed in the making of this lab.

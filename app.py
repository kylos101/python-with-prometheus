from flask import Flask
from prometheus_client import start_http_server, Gauge
import requests

app = Flask(__name__)

@app.route("/")
def serve():
    return "Hello, world!"

def get_running_pod_count():
    # limited to the default namespace for now...
    # https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podlist-v1-core
    r = requests.get('https://kubernetes.default.svc.cluster.local:8080/api/v1/namespaces/default/pods')
    r.raise_for_status()
    items = r.json()
    return len(items)

def get_running_pod_metrics():
    g = Gauge('running_pod_count', 'The number of running pods')
    g.set_function(lambda: get_running_pod_count())

# Start up the server to expose the metrics.
start_http_server(8000)
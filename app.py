# from flask import Flask
from prometheus_client import start_http_server, Gauge
import requests
import time
import sys
import traceback

def get_running_pod_total():
    # limited to the default namespace for now...
    # https://v1-18.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.18/#podlist-v1-core
    
    items = 0
    try:
        r = requests.get('https://kubernetes.default.svc.cluster.local/api/v1/namespaces/default/pods')
        r.raise_for_status()
        response = r.json()
        items = len(response["items"])
    except Exception:
        msg = traceback.format_exc()
        print(msg, file=sys.stderr)
    finally:
        return items

def set_metrics():
    g = Gauge('running_pod_total', 'The number of running pods')
    value = get_running_pod_total()
    print(f'The value is {value}', file=sys.stderr)
    g.set(value)

# Start up the server to expose the metrics.
if __name__ == '__main__':
    # Start up the server to expose the metrics.
    set_metrics()
    start_http_server(port=8090,addr='0.0.0.0')
    while True:
        time.sleep(0.001)



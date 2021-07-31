# from flask import Flask
from prometheus_client import start_http_server, Gauge
from kubernetes import client, config
import time
import sys

g = Gauge('running_pod_total', 'The number of running pods')

def get_running_pod_total():
    config.load_incluster_config()
    v1 = client.CoreV1Api()
    
    # requires rbac
    # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
    ret = v1.list_pod_for_all_namespaces(watch=False)
    return len(ret.items)
    
def set_metrics():    
    value = get_running_pod_total()
    print(f'The value is {value}', file=sys.stderr)
    g.set(value)

def get_secret(path: str) -> str:
    """Get a secret from a file."""
    location = path
    with open(location, "r") as fo:
        line = fo.readline().strip()
    return line

# Start up the server to expose the metrics.
if __name__ == '__main__':
    # Start up the server to expose the metrics.
    print("Starting up...", file=sys.stderr)
    set_metrics()
    start_http_server(port=8090,addr='0.0.0.0')
    while True:
        time.sleep(1)     
        set_metrics()
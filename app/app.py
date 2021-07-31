# from flask import Flask
from prometheus_client import Gauge, Counter, make_wsgi_app
from kubernetes import client, config
from flask import Flask
from werkzeug.middleware.dispatcher import DispatcherMiddleware
from werkzeug.serving import run_simple
import time
import sys
import traceback
import threading

g = Gauge('running_pods', 'The number of running pods now')
c = Counter('app_hello_world', 'Hello World accessed')
app = Flask(__name__)

@app.route("/")
@c.count_exceptions()
def hello():
    c.inc()
    return "Hello, World!"

with c.count_exceptions():
    e = traceback.format_exc()
    print(e, file=sys.stderr)

def get_running_pod_total():
    config.load_incluster_config()
    v1 = client.CoreV1Api()
    
    # requires rbac
    # https://github.com/kubernetes-client/python/blob/master/examples/in_cluster_config.py
    items = v1.list_pod_for_all_namespaces(watch=False).items
    value = 0
    for i in items:
        # i is a https://github.com/kubernetes-client/python/blob/master/kubernetes/docs/V1Pod.md
        if i.status.phase == "Running":
            value += 1
    return value
    
def set_gauge():    
    value = get_running_pod_total()
    g.set(value)
    while True:
        time.sleep(1)     
        set_gauge()

# Init
print("Starting up...", file=sys.stderr)
th = threading.Thread(target=set_gauge)
th.start()
dispatcher = DispatcherMiddleware(app.wsgi_app, {"/metrics": make_wsgi_app()})
run_simple(hostname="0.0.0.0", port=5000, application=dispatcher)

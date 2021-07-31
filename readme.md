# Run a Python app on Kubernetes and instrument it with Prometheus

## Overview

1. `app` - a Python app for which we'll create a docker image, run in Kubernetes, and instrument with Prometheus
2. `k8s_resources` - the Kubernetes resources required to run the Python app
3. `scripts` - scripts to setup your local machine, including a test cluster for the app using k3d

## Setup

1. Change `DOCKER_REPO` in [image-build.sh](./scripts/image-build.sh) to your public [Docker Repo])(https://hub.docker.com/), mine is `kylos101`.
2. Replace `kylos101` in `template.spec.containers[0].image` with your Docker Repo in [deployment.yaml](.k8s_resources/../k8s_resources/deployment.yaml).
3. Walk through the setup in [cluster-install.sh](./scripts/cluster-install.sh).

## Test the app

1. Run the commands in [port-forwards.sh](./scripts/port-forwards.sh) and click the related links to inspect and update Prometheus metrics.
2. `running_pods` is a Gauge metric, and shows the total # of running pods in Kubernetes.
3. `app_hello_world` is a Counter metric, and increments each time we hit the `https://localhost:5000` endpoint.

## Questions

### How is the app creating and updating Prometheus metrics?

[Using client libraries.](https://prometheus.io/docs/instrumenting/clientlibs/)

### How is the app interacting with the Kubernetes API to get the # of running pods?

[Using client libraries.](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/#programmatic-access-to-the-api)

### How does Prometheus know to collect metrics from the Python app?

The Prometheus chart ingests metrics from pods if they have [corresponding annotations](https://artifacthub.io/packages/helm/prometheus-community/prometheus#scraping-pod-metrics-via-annotations). You'll see them in [deployment.yaml](.k8s_resources/../k8s_resources/deployment.yaml).

## Troubleshooting

1. [Not seeing metrics in Prometheus? Check if the target endpoint listed and up or down in Prometheus .](http://localhost:8082/targets)

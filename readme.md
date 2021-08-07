# Instrument a Python app with Prometheus and run it on Kubernetes

A lab to help you setup, explore, and test Prometheus metrics using a Python app running on Kubernetes. Enjoy!

## Folder structure

1. `app` - a Python app for which we'll create a docker image, run in Kubernetes, and see that it is instrumented with Prometheus
2. `k8s_resources` - the Kubernetes resources required to run the Python app
3. `scripts` - supporting scripts
4. `lab` - documentation to help you setup a development Kubernetes cluster and test the app

## Before you get started

Please work from one terminal only. Why?

1. In the beginning, we temporarily alter the path and set environment variables.
2. At the end, we rely on previously set environment variables to do tear-down, and return your computer to a predictable state.

## Instructions

1. Clone this repo
2. Replace `kylos101` in [image-build.sh](./scripts/image-build.sh) with your own account on [Docker Hub](https://hub.docker.com/).
3. Replace `kylos101` for `template.spec.containers[0].image` with your account on Docker Hub in [deployment.yaml](./k8s_resources/deployment.yaml).
4. [Setup a lab environment](./lab/setup.md).
5. [Explore, test, and then teardown the lab environment](./lab/testing.md).

## Questions

### How is the app creating and updating Prometheus metrics?

[Using client libraries.](https://prometheus.io/docs/instrumenting/clientlibs/)

### How is the app interacting with the Kubernetes API to get the # of running pods?

[Using client libraries.](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-api/#programmatic-access-to-the-api)

### How does Prometheus know to collect metrics from the Python app?

The Prometheus chart ingests metrics from pods if they have [corresponding annotations](https://artifacthub.io/packages/helm/prometheus-community/prometheus#scraping-pod-metrics-via-annotations). You'll see them in [deployment.yaml](https://github.com/kylos101/python-with-prometheus/blob/877e9cdf5d977cd6f5f955df1a6f62dd8d286f7b/k8s_resources/deployment.yaml#L16-L19).

## Troubleshooting

1. Not seeing metrics in Prometheus? [Port forward to Prometheus, and check if the target endpoint is listed, and if it is up/down.](http://localhost:8082/targets)

# exit when any command fails
set -e

pushd ./app

# build our image
DOCKER_REPO=kylos101
VERSION=1.0.0
IMAGE=$(docker build -q -t python-with-prometheus . | cut -d: -f2)

# Uncomment me to test the image locally
# docker run -p 8081:8000 -p 8080:5000 -it --rm --name slytherin-slimes python-with-prometheus

# Prepare and push to a Docker Registry
docker tag $IMAGE $DOCKER_REPO/python-with-prometheus:$VERSION
docker push $DOCKER_REPO/python-with-prometheus:$VERSION

# Use the new image
kubectl rollout restart deployments/python-with-prometheus

popd
# exit when any command fails
set -e

pushd ./app

# build our image
IMAGE=$(docker build -q -t python-with-prometheus . | cut -d: -f2)

# Uncomment me to test the image locally
# docker run -p 8081:8000 -p 8080:5000 -it --rm --name slytherin-slimes python-with-prometheus

# Prepare and push to a Docker Registry
VERSION=0.0.17
docker tag $IMAGE kylos101/python-with-prometheus:$VERSION
docker push kylos101/python-with-prometheus:$VERSION

# Use the new image
sleep 3
kubectl rollout restart deployments/python-with-prometheus

popd
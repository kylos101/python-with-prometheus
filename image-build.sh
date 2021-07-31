# build our image
docker build -t python-with-prometheus .

# Uncomment me to test the image locally
# docker run -p 8081:8000 -p 8080:5000 -it --rm --name slytherin-slimes python-with-prometheus

# Prepare and push to a Docker Registry
docker tag 8cd311638cfe kylos101/python-with-prometheus:0.0.16
docker push kylos101/python-with-prometheus:0.0.16
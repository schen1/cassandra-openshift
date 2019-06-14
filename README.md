# Cassandra on Kubernetes/OpenShift

## Docker build
docker build --build-arg CASSANDRA_VERSION=3.11.4 . -t sychen/cassandra

## Docker tag
docker tag sychen/cassandra quay.io/sychen/cassandra:3.11

## Docker push
docker push quay.io/sychen/cassandra:3.11

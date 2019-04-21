set -x
set -e

docker build \
    -t rhtakealot/multi-client:latest \
    -t rhtakealot/multi-client:$SHA \
    -f ./client/Dockerfile ./client
docker build \
    -t rhtakealot/multi-server:latest \
    -t rhtakealot/multi-server:$SHA \
    -f ./server/Dockerfile ./server
docker build \
    -t rhtakealot/multi-worker:latest \
    -t rhtakealot/multi-worker:$SHA \
    -f ./worker/Dockerfile ./worker

# client
docker push rhtakealot/multi-client:latest
docker push rhtakealot/multi-client:$SHA
# server
docker push rhtakealot/multi-server:latest
docker push rhtakealot/multi-server:$SHA
# worker
docker push rhtakealot/multi-worker:latest
docker push rhtakealot/multi-worker:$SHA

kubectl apply -f k8s

kubectl set image deployments/server-deployment \
    server=rhtakealot/multi-server:$SHA
kubectl set image deployments/client-deployment \
    client=rhtakealot/multi-client:$SHA
kubectl set image deployments/worker-deployment \
    worker=rhtakealot/multi-worker:$SHA

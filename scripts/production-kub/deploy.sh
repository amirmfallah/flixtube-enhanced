#
# Builds, publishes and deploys all microservices to a production Kubernetes instance.
#
# Usage:
#
#   ./scripts/production-kub/deploy.sh
#

set -u # or set -o nounset
: "$CONTAINER_REGISTRY"

#
# Build Docker images.
#
docker build -t $CONTAINER_REGISTRY/metadata:$VERSION --file ../../metadata/Dockerfile-prod ../../metadata
docker push $CONTAINER_REGISTRY/metadata:$VERSION

docker build -t $CONTAINER_REGISTRY/history:$VERSION --file ../../history/Dockerfile-prod ../../history
docker push $CONTAINER_REGISTRY/history:$VERSION

docker build -t $CONTAINER_REGISTRY/azure-storage:$VERSION --file ../../azure-storage/Dockerfile-prod ../../azure-storage
docker push $CONTAINER_REGISTRY/azure-storage:$VERSION

docker build -t $CONTAINER_REGISTRY/history:$VERSION --file ../../history/Dockerfile-prod ../../history
docker push $CONTAINER_REGISTRY/history:$VERSION

docker build -t $CONTAINER_REGISTRY/video-streaming:$VERSION --file ../../video-streaming/Dockerfile-prod ../../video-streaming
docker push $CONTAINER_REGISTRY/video-streaming:$VERSION

docker build -t $CONTAINER_REGISTRY/video-upload:$VERSION --file ../../video-upload/Dockerfile-prod ../../video-upload
docker push $CONTAINER_REGISTRY/video-upload:$VERSION

docker build -t $CONTAINER_REGISTRY/gateway:$VERSION --file ../../gateway/Dockerfile-prod ../../gateway
docker push $CONTAINER_REGISTRY/gateway:$VERSION

# 
# Deploy containers to Kubernetes.
#
# Don't forget to change kubectl to your production Kubernetes instance
#
kubectl apply -f rabbit.yaml
kubectl apply -f mongodb.yaml 
envsubst < metadata.yaml | kubectl apply -f -
envsubst < history.yaml | kubectl apply -f -
envsubst < azure-storage.yaml | kubectl apply -f -
envsubst < video-streaming.yaml | kubectl apply -f -
envsubst < video-upload.yaml | kubectl apply -f -
envsubst < gateway.yaml | kubectl apply -f -
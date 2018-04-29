PROJECT="cd-pipeline-poc"
DOCKER_REGISTRY="eu.gcr.io"
DOCKER_TAG=`git rev-parse HEAD`
KEY_FILENAME="gcr-service-key.json"

# Build binaries
CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o api cmd/api/main.go
CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o cms cmd/cms/main.go
CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o sap cmd/sap/main.go
# CGO_ENABLED=0 GOOS=linux go build -installsuffix cgo -o api cmd/frontend/main.go

# Build Docker images
docker build . \
  --tag ${DOCKER_REGISTRY}/${PROJECT}/api:${DOCKER_TAG} \
  --file cmd/api/Dockerfile

docker build . \
  --tag ${DOCKER_REGISTRY}/${PROJECT}/cms:${DOCKER_TAG} \
  --file cmd/cms/Dockerfile

docker build . \
  --tag ${DOCKER_REGISTRY}/${PROJECT}/sap:${DOCKER_TAG} \
  --file cmd/sap/Dockerfile

# docker build . \
#   --tag ${DOCKER_REGISTRY}/${PROJECT}/frontend:${DOCKER_TAG} \
#   --file cmd/frontend/Dockerfile

# Get authentication key to file
echo ${CIRCLE_GCR_KEY} > ${HOME}/${KEY_FILENAME}

# GCR Authentication
docker login https://${DOCKER_REGISTRY} \
  -u _json_key --password-stdin < ${HOME}/${KEY_FILENAME}

# Push Docker images to GCR
docker push ${DOCKER_REGISTRY}/${PROJECT}/api:${DOCKER_TAG}
docker push ${DOCKER_REGISTRY}/${PROJECT}/cms:${DOCKER_TAG}
docker push ${DOCKER_REGISTRY}/${PROJECT}/sap:${DOCKER_TAG}
#docker push ${DOCKER_REGISTRY}/${PROJECT}/frontend:${DOCKER_TAG}

# Clean built Docker images
docker rmi --force ${DOCKER_REGISTRY}/api:${DOCKER_TAG}
docker rmi --force ${DOCKER_REGISTRY}/cms:${DOCKER_TAG}
docker rmi --force ${DOCKER_REGISTRY}/sap:${DOCKER_TAG}
#docker rmi --force ${DOCKER_REGISTRY}/frontend:${DOCKER_TAG}

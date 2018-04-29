CLUSTER_NAME="app-cluster"
PROJECT="cd-pipeline-poc"
DOMAIN="cd-pipeline-poc.iam.gserviceaccount.com"
GKE_SERVICE_ACCOUNT="circleci-gke-cluster-manager@${DOMAIN}"
KEY_FILENAME="gke-service-key.json"
NAMESPACE=$1

# Get authentication key to file
echo ${CIRCLE_GKE_KEY} > ${HOME}/${KEY_FILENAME}

# Authenticate to Google Cloud
gcloud auth activate-service-account ${GKE_CLUSTER_MANAGER_ACCOUNT} \
  --key-file=${HOME}/${KEY_FILENAME}

# Install kubectl if needed
if [[ $(kubectl version) != 0 ]]; then
  gcloud components install kubectl
fi

# Get cluster credential
gcloud container clusters get-credentials ${CLUSTER_NAME} \
  --project ${PROJECT} \
  --zone europe-west1-b

# Inject environment variable into kubernetes configuration files
FILES=$(find kubernetes -type f -name "*.yml" -maxdepth 1)
rm -rf kubernetes/dist
mkdir -p kubernetes/dist

for file in ${FILES}
do
  fileName=$(echo ${file} | sed 's/kubernetes\///')
  envsubst < ${file} > kubernetes/dist/${fileName}
done

# Create a namespace if not exist
if [[ $(kubectl get namespace ${NAMESPACE}) != 0 ]]; then
  kubectl create namespace ${NAMESPACE}
fi

# Deploy new version
kubectl apply --namespace ${NAMESPACE} \
  -f kubernetes/

# Clean deployment configuration files
rm -rf kubernetes/dist

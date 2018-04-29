CLUSTER_NAME="app-cluster"
PROJECT="cd-pipeline-poc"
DOMAIN="cd-pipeline-poc.iam.gserviceaccount.com"
GKE_SERVICE_ACCOUNT="circleci-gke-cluster-manager@${DOMAIN}"
KEY_FILENAME="gke-service-key.json"

# Get authentication key to file
echo ${CIRCLE_GKE_KEY} > ${HOME}/${KEY_FILENAME}

# Authenticate to Google Cloud
gcloud auth activate-service-account ${GKE_CLUSTER_MANAGER_ACCOUNT} \
  --key-file=${HOME}/${KEY_FILENAME}

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

if [[ ${CIRCLE_BRANCH} -ne "master" ]]; then
  UNIFIED_BRANCH=`echo ${CIRCLE_BRANCH} | sed 's/\//-/g' | sed 's/_/-/g' | sed 's/\./-/g' | awk '{print tolower($0)}'`
  NAMESPACE=${UNIFIED_BRANCH}-${CIRCLE_PR_NUMBER}

  # Create a namespace if not exist
  if [[ $(kubectl get namespace ${NAMESPACE}) != 0 ]]; then
    kubectl create namespace ${NAMESPACE}
  fi
else
  NAMESPACE="production"
fi

# Deploy new version
kubectl apply --namespace ${NAMESPACE} \
  -f kubernetes/

# Clean deployment configuration files
rm -rf kubernetes/dist

#!/bin/bash
# get token
KUBE_TOKEN=$(</var/run/secrets/kubernetes.io/serviceaccount/token)

# deployment updater
stdbuf -o0 curl -sSk -H "Authorization: Bearer $KUBE_TOKEN"   https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/watch/namespaces/$MY_POD_NAMESPACE/configmaps/ | jq --unbuffered  '.object.metadata.name+ ":" +.object.metadata.resourceVersion' | while read line; do
line=`echo $line | sed 's/\"//g'`
export cm_name=`echo $line | cut -d : -f1`
export version=`echo $line |cut -d : -f2`
echo "Rerolling Deployments that use ConfigMap: $cm_name"
kubectl --namespace=$MY_POD_NAMESPACE get deployments -o json  |\
# filter by deployments that use the updated configmap
jq  --unbuffered   '.items[]|select(.spec.template.spec.containers[]?.env[]?.valueFrom.configMapKeyRef.name == env.cm_name), select(.spec.template.spec.containers[]?.envFrom[]?.configMapRef.name == env.cm_name)|.metadata.name' |\
# get rid of duplicates
uniq |\
# trigger deployment rollouts
xargs -I {} kubectl --namespace=$MY_POD_NAMESPACE patch deployment {}  --type json  -p='[{"op": "replace", "path": "/spec/template/metadata/labels/version", "value":'"'$version'"'}]'  ;done&

# secret updater
stdbuf -o0 curl -sSk -H "Authorization: Bearer $KUBE_TOKEN"   https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/watch/namespaces/$MY_POD_NAMESPACE/secrets/ | jq --unbuffered  '.object.metadata.name+ ":" +.object.metadata.resourceVersion' | while read line; do
line=`echo $line | sed 's/\"//g'`
export cm_name=`echo $line | cut -d : -f1`
export version=`echo $line |cut -d : -f2`
echo "Rerolling Deployments that use Secrets: $cm_name"
kubectl --namespace=$MY_POD_NAMESPACE get deployments -o json  |\
# filter by deployments that use the updated secret
jq  --unbuffered   '.items[]|select(.spec.template.spec.containers[]?.env[]?.valueFrom.secretKeyRef.name == env.cm_name), select(.spec.template.spec.containers[]?.envFrom[]?.secretRef.name == env.cm_name)|.metadata.name' |\
# get rid of duplicates
uniq |\
# trigger deployment rollouts
xargs -I {} kubectl --namespace=$MY_POD_NAMESPACE patch deployment {}  --type json  -p='[{"op": "replace", "path": "/spec/template/metadata/labels/version", "value":'"'$version'"'}]'  ;done&

# keep script running
wait


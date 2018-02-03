# kubernetes-configmap-rollouts

A Bash script that will continuously poll **Kubernetes** api for **configmaps** changes in the current namespace and start a rollout on the deployments using those configmaps

## Installation

`kubectl create -f https://raw.githubusercontent.com/aabed/kubernetes-configmap-rollouts/master/kubernetes-configmap-rollouts.yaml`

## More

Check the opened issue on kubernetes repo https://github.com/kubernetes/kubernetes/issues/22368



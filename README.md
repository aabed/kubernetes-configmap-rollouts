# kubernetes-configmap-rollouts

A Bash script that will query **Kubernetes** watch api for **configmaps** changes in the current namespace and start a rollout on the deployments using those configmaps

## Installation

`kubectl create -f https://raw.githubusercontent.com/aabed/kubernetes-configmap-rollouts/master/kubernetes-configmap-rollouts.yaml`

**Note:** This module updates deployments based on `/spec/template/metadata/labels/version`, please make sure your deployments contain this label.

## More

Check the opened issue on kubernetes repo https://github.com/kubernetes/kubernetes/issues/22368



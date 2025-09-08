#!/usr/bin/env nu 
def deploy-cleanup [namespace?: string] {
  if ($namespace == null) {
    print "No namespace provided, exiting"
    exit 1
  }     
  # Get all CrashLoopBackOff pods in the namespace and delete them
  let pods = (kubectl get pods -n $namespace -o json | from json)
  let badPods = ($pods | where status.containerStatuses[].state.waiting.reason == "CrashLoopBackOff" | get metadata.name)
  for $pod in $badPods {
    echo "Deleting $pod in $namespace..."
    kubectl delete pod $pod -n $namespace
  }
}

#!/usr/bin/env nu
# kclean.nu: Delete all CrashLoopBackOff pods in a given namespace
def main [namespace: string] {
    let pods = (kubectl get pods -n $namespace -o json | from json | get items)
    let badpods = ($pods | where status.containerStatuses[].state.waiting.reason == "CrashLoopBackOff" | get metadata.name)
    if ($badpods | length) == 0 {
        print "No CrashLoopBackOff pods in namespace ($namespace)."
        exit 0
    }
    for $p in $badpods {
        print "Deleting pod ($p)..."
        kubectl delete pod $p -n $namespace
    }
}

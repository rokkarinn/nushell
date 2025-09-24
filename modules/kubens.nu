export def kns-update-cache [] {
  mkdir $"($env.HOME)/.kube/kubectx-cache"
  kubectl get ns -o json | from json | get items | get metadata.name | to text | save --force $"($env.HOME)/.kube/kubectx-cache/(yq -r '.current-context' ($env.KUBECONFIG) | cut -d'/' -f2)"
}

def namespaces [] {
  let namespaces = kubectl get ns -o json 
  | from json 
  | get items 
  | get metadata.name 
  | collect

  { completions: $namespaces, options: { sort: false } }
}

export def --env kns [ns?: string@namespaces = ""] {
  kns-update-cache
  $env.currenctContext = $"(yq -r '.current-context' ($env.KUBECONFIG) | cut -d'/' -f2)"
  cat $"($env.HOME)/.kube/kubectx-cache/(yq -r '.current-context' ($env.KUBECONFIG) |  cut -d'/' -f2)" | fzf --query $ns |  xargs -L1 -I% yq e -i '.contexts[].context.namespace = "%"' ($env.KUBECONFIG)
  let namespace = $"(yq '.contexts[] | select(.name==env(currenctContext)).context.namespace' ($env.KUBECONFIG))"
  print $"Context ($env.currenctContext) modified."
  print $"Active namespace is ($namespace)"
}

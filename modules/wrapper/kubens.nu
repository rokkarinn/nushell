export def kns-update-cache [] {
  update-current-context
  let cacheDir: string = $"($env.HOME)/.kube/kubectx-cache"
  let cacheFilePath: string = $"($cacheDir)/($env.currentContext)"
  if not ($"($cacheDir)" | path exists) {
    mkdir $"($cacheDir)"
  }
  mut updateCache: bool = false
  if not ($cacheFilePath | path exists) {
    $updateCache = true
  } else if ( (date now) - (ls $cacheFilePath | get modified.0 ) > 1day) {
    $updateCache = true
  }
  if ($updateCache) {
    kubectl get ns -o json 
    | from json 
    | get items 
    | get metadata.name 
    | to text 
    | save --force $cacheFilePath
  }
}

export def update-current-context [] {
  $env.currentContext = open $env.KUBECONFIG | from yaml | get current-context
}

export def namespaces [] {
  update-current-context
  kns-update-cache
  let namespaces = open $"($env.HOME)/.kube/kubectx-cache/($env.currentContext)" 
  | collect
  { completions: $namespaces, options: { sort: false } }
}

export def --env kns [ns?: string@namespaces = ""] {
  update-current-context
  cat $"($env.HOME)/.kube/kubectx-cache/(yq -r '.current-context' ($env.KUBECONFIG) |  cut -d'/' -f2)" | fzf --query $ns |  xargs -L1 -I% yq e -i '.contexts[].context.namespace = "%"' ($env.KUBECONFIG)
  let ns = $"(yq '.contexts[] | select(.name==env(currentContext)).context.namespace' ($env.KUBECONFIG))"
  print $"Context ($env.currentContext) modified."
  print $"Active namespace is ($ns)"
  kns-update-cache
}

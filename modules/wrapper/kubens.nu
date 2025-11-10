export def kns-update-cache [--force(-f)] {
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
  } else if ($force) {
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

export def --env update-current-context [] {
  $env.currentContext = open $env.KUBECONFIG | from yaml | get current-context
}

def ns [] {
  update-current-context
  kns-update-cache
  let namespaces = open $"($env.HOME)/.kube/kubectx-cache/($env.currentContext)"
  | lines
  | collect
  { completions: $namespaces, options: { sort: false } }
}

export def kns [nsp?: string@ns] {
  update-current-context
  kns-update-cache
  if not ($nsp | is-empty) {
    kubectl config set-context --current --namespace=$"($nsp)"
  } else {
    cat $"($env.HOME)/.kube/kubectx-cache/(yq -r '.current-context' ($env.KUBECONFIG) |  cut -d'/' -f2)" | fzf --tac |  xargs -L1 -I% yq e -i '.contexts[].context.namespace = "%"' ($env.KUBECONFIG)
    print $"Context ($env.currentContext) modified."
  }
  let namesp = $"(yq '.contexts[] | select(.name==env(currentContext)).context.namespace' ($env.KUBECONFIG))"
  print $"Active namespace is ($namesp)"
  kns-update-cache
}

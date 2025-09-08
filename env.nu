let home_bin: string = ($env.HOME | path join "bin")
$env.PATH = ($env.PATH | split row (char esep) | append $home_bin | uniq)
let brew_home_bin = "/opt/homebrew/bin"
$env.PATH = ($env.PATH | split row (char esep) | append $brew_home_bin | uniq)
let npm_global_bin = ($env.HOME | path join "/opt/homebrew/lib/node_modules" "bin")
$env.PATH = ($env.PATH | split row (char esep) | append $npm_global_bin | uniq)
let rancher_desktop_bin = ($env.HOME | path join ".rd/bin")
$env.PATH = ($env.PATH | split row (char esep) | append $rancher_desktop_bin | uniq)
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'


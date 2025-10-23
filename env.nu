let home_bin: string = ( $env.HOME | path join "bin" )
$env.PATH = ( $env.PATH | split row ( char esep ) | append $home_bin | uniq )

#homebrew
$env.HOMEBREW_PREFIX = "/opt/homebrew";
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar";
$env.HOMEBREW_REPOSITORY = "/opt/homebrew";
$env.HOMEBREW_ROSETTA = 1
use std "path add"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"

let npm_global_bin = ( $env.HOME | path join "/opt/homebrew/lib/node_modules" "bin" )
$env.PATH = ( $env.PATH | split row ( char esep ) | append $npm_global_bin | uniq )
let rancher_desktop_bin = ( $env.HOME | path join ".rd/bin" )
$env.PATH = ( $env.PATH | split row ( char esep ) | append $rancher_desktop_bin | uniq )
let kubectl_krew = ( $env.HOME | path join ".krew" )
let kubectl_krew_bin = ( $kubectl_krew | path join "bin" )
$env.PATH = ( $env.PATH | split row ( char esep ) | append $kubectl_krew | uniq )
$env.PATH = ( $env.PATH | split row ( char esep ) | append $kubectl_krew_bin | uniq )
let cargo_bin: string = ( $env.HOME | path join ".cargo/bin" )
$env.PATH = ( $env.PATH | split row ( char esep ) | append $cargo_bin | uniq )
let go_bin: string = ( $env.HOME | path join ".cargo/bin" )
$env.PATH = ( $env.PATH | split row ( char esep ) | append $go_bin | uniq )
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.config.buffer_editor = 'nvim'
$env.config.edit_mode = 'vi'
let ZELLIJ_AUTO_ATTACH: bool = true
let ZELLIJ_AUTO_EXIT: bool = true 
$env.ZELLIJ_AUTO_ATTACH = $ZELLIJ_AUTO_ATTACH
$env.ZELLIJ_AUTO_EXIT = $ZELLIJ_AUTO_EXIT
$env.EDITOR = 'nvim'
$env.VISUAL = 'nvim'
$env.NUPM_HOME = ( $nu.default-config-dir | path join "nupm" )
let nupm_bin: string = ( $env.NUPM_HOME | path join "bin" )
$env.PATH = ( $env.PATH | split row ( char esep ) | prepend $nupm_bin | uniq )
$env.NU_LIB_DIRS = ( $env.NU_LIB_DIRS | append ( $env.NUPM_HOME | path join "modules" ) | uniq )
$env.NU_LIB_DIRS = ( $env.NU_LIB_DIRS | append ( $env.NUPM_HOME | path join "overlays" ) | uniq )
let nupm_scripts: string = ( $env.NUPM_HOME | path join "scripts" )
$env.PATH = ( $env.PATH | split row ( char esep ) | prepend $nupm_scripts | uniq )

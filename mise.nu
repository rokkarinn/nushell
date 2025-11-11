set,PATH,/Users/ivarbj/Git/config/nushell/nupm/scripts:/Users/ivarbj/Git/config/nushell/nupm/bin:/opt/homebrew/sbin:/opt/homebrew/bin:/Users/ivarbj/.local/share/nvim/mason/bin:/Users/ivarbj/.asdf/installs/neovim/0.11.4/bin:/Users/ivarbj/.asdf/shims:/Users/ivarbj/Library/Application Support/carapace/bin:/Applications/kitty.app/Contents/MacOS:/usr/bin:/bin:/usr/sbin:/sbin:/Users/ivarbj/bin:/opt/homebrew/lib/node_modules/bin:/Users/ivarbj/.rd/bin:/Users/ivarbj/.krew:/Users/ivarbj/.krew/bin:/Users/ivarbj/.cargo/bin:/usr/local/bin
hide,MISE_SHELL,
hide,__MISE_DIFF,
hide,__MISE_DIFF,
export-env {
  
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/opt/homebrew/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/opt/homebrew/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/opt/homebrew/bin/mise" $command ...$rest
  }
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name | str upcase) == 'PATH' {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" {
      hide-env $var.name
    }
  }
}

def --env mise_hook [] {
  ^"/opt/homebrew/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}


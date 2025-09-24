let asdf_data_dir = (
  if ( $env | get --optional ASDF_DATA_DIR | is-empty ) {
    $env.HOME | path join '.asdf'
  } else {
    $env.ASDF_DATA_DIR
  }
)
"$asdf_data_dir/completions/nushell.nu"

let shims_dir = (
  if ( $env | get --optional ASDF_DATA_DIR | is-empty ) {
    $env.HOME | path join '.asdf'
  } else {
    $env.ASDF_DATA_DIR
  } | path join 'shims'
)
$env.PATH = ( $env.PATH | split row (char esep) | where { |p| $p != $shims_dir } | prepend $shims_dir )

# asdf install
def ai [name?: string = ''] {
  mut plugin = $name
  if $name == '' {
    $plugin = (
      asdf plugin list |
      get name |
      str join (char nl) |
      fzf --reverse
    )
  }

  if $plugin != '' {
    let version = (
      asdf list all $plugin |
      get version |
      append "latest" |
      str join (char nl) |
      fzf
    )
    if $version != '' {
      asdf install $plugin $version
    }
  }
}

# asdf use
def au [name?: string = ''] {
  mut plugin = $name
  if $name == '' {
    $plugin = (
      asdf plugin list |
      get name |
      str join (char nl) |
      fzf --reverse
    )
  }

  if $plugin != '' {
    let version = (
      asdf list $plugin |
      split row "\n" |
      str trim |
      where ($it !~ '\*') |
      where ($it != '') |
      append "latest" |
      str join (char nl) |
      fzf
    )
    if $version != '' {
      asdf global $plugin $version
    }
  }
}

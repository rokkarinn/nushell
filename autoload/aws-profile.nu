def profiles [] {
  {
    options: {
      case_sensitive: false,
      completion_algorithm: substring,
      sort: false,
    },
    completions: [ ( open ~/.aws/config.leapp | lines | where $it =~ '^\[profile (\w+)\]' | str replace -r '\[profile ' '' | str replace -r '\]' '' ) ]
  }
}

#def --env aws-profile [profile?: string@profiles] {
def --env aws-profile [profile?: string] {
  let nglId = (leapp integration list -x --filter="Integration Name=AWS NextGL" | awk 'NF>1{print $1}' | tail -1)
  let pblId = (leapp integration list -x --filter="Integration Name=AWS PBL" | awk 'NF>1{print $1}' | tail -1)
  let nglstatus = (leapp integration list --filter="Integration Name=AWS NextGL" | grep -wi Online | awk 'NF>1{print $6}')
  let pblstatus = (leapp integration list --filter="Integration Name=AWS PBL" | grep -wi Online | awk 'NF>1{print $6}')
  if ($nglstatus | is-empty) {
    leapp integration login --integrationId $nglId
  } 
  if ($pblstatus | is-empty) {
    leapp integration login --integrationId $pblId
  }
  export-env {
    $env.AWS_CONFIG_FILE = '/Users/ivarbj/.aws/config.leapp'
  }
  if ( $profile | is-empty ) {
    export-env {
      $env.AWS_PROFILE = ( open ~/.aws/config.leapp | lines | where $it =~ '^\[profile (\w+)\]' | str replace -r '\[profile ' '' | str replace -r '\]' '' | str join (char nl) | fzf)
    }
  } else {
    export-env {
      $env.AWS_PROFILE = ( open ~/.aws/config.leapp | lines | where $it =~ '^\[profile (\w+)\]' | str replace -r '\[profile ' '' | str replace -r '\]' '' | str join (char nl) | fzf --query $profile )
    }
  }
  $env.KUBECONFIG = $"/Users/ivarbj/.kube/($env.AWS_PROFILE).kube"
  let sessionStatus = (leapp session list --filter=$"Named Profile=($env.AWS_PROFILE)" | grep -wi active | awk 'NF>1{print $NF}')
  if $sessionStatus == "active" {
    leapp session stop $"($env.AWS_PROFILE)"
  }
  leapp session start (leapp session list --filter=$"Named Profile=($env.AWS_PROFILE)" | Tail -1 | sed -E "s/ AWS Single Sign-On.*//" | str trim)
  print $"Switched to aws profile ($env.AWS_PROFILE)."
}

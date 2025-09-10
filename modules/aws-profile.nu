def profiles [] {
  let profiles = open ~/.aws/config.leapp 
  | lines 
  | where $it =~ profile 
  | str replace '[profile' 'profile =' 
  | str replace ']' '' 
  | split column --regex '(\s=\s|\s)' -n 2 
  | get column2 
  | collect

  { completions: $profiles, options: { sort: false } }
}

export def --env aws-profile [profile?: string@profiles] {
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
      $env.AWS_PROFILE = ( open ~/.aws/config.leapp | lines | where $it =~ profile | str replace '[profile' 'profile =' | str replace ']' '' | str replace -a '"' '' | split column --regex '(\s=\s|\s)' -n 2 | get column2 | to text | fzf)
    }
  } else {
    export-env {
      $env.AWS_PROFILE = ( open ~/.aws/config.leapp | lines | where $it =~ profile | str replace '[profile' 'profile =' | str replace ']' '' | str replace -a '"' '' | split column --regex '(\s=\s|\s)' -n 2 | get column2 | to text | fzf --query $profile )
    }
  }
  $env.KUBECONFIG = $'/Users/ivarbj/.kube/($env.AWS_PROFILE).kube'
  let sessionStatus = (leapp session list -x --output json | from json | where profileId == $env.AWS_PROFILE | get status).0
  if $sessionStatus == "active" {
    leapp session stop $"($env.AWS_PROFILE)"
  }
  leapp session start $env.AWS_PROFILE
  print $"Switched to aws profile ($env.AWS_PROFILE)."
}

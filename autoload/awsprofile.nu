#!/usr/bin/env nu
def --env awsprofile [profile: string] {
  let aws_env = [
    AWS_DEFAULT_REGION
    AWS_CONFIG_FILE
    AWS_ACCESS_KEY_ID
    AWS_PROFILE
    AWS_SECRET_ACCESS_KEY
    AWS_SESSION_TOKEN
    AWS_SDK_LOAD_CONFIG
  ]
  $aws_env | where $it in $env | hide-env ...$in
  export-env { $env.AWS_CONFIG_FILE = "/Users/ivarbj/.aws/config.leapp" }

  if ($profile | is-empty) {
    let profile = (aws configure list-profiles | awk '! /profile/' | fzf )
  }
  let idx0 = ((cat ~/.aws/config.leapp | lines | enumerate | find $"[profile ($profile)]" | get index) | into int).0 | into int
  let idx1 = $idx0 + 1
  let idx2 = $idx1 + 1
  let idx3 = $idx2 + 1
  let idx4 = $idx3 + 1
  let session = (leapp session list --filter=$"Named Profile=($profile)" | Tail -1 | sed -E "s/ AWS Single Sign-On.*//" | str trim)
  let sessionStatus = (leapp session list --filter=$"Named Profile=($profile)" | grep -wi active | awk 'NF>1{print $NF}')
  let profilesection = ( open $env.AWS_CONFIG_FILE | lines | enumerate | select $idx0 $idx1 $idx2 $idx3 $idx4 )
  print $profilesection
  let region = $"((( $profilesection | find region | get item ).0 | split row "=" ).1 | str trim | into string)"
  let role = (( $profilesection | find sso_role_name | get item ).0 | split row "=" ).1 | str trim | into string

  if $sessionStatus == "active" {
    leapp session stop $"($session)"
  }
  leapp session start (leapp session list --filter=$"Named Profile=($profile)" | Tail -1 | sed -E "s/ AWS Single Sign-On.*//" | str trim)

  #  let cidx0 = (cat ~/.aws/credentials | lines | enumerate | find $"[NGLDev]" | get index ).0 | into int
  #  let cidx1 = $cidx0 + 1
  #  let cidx2 = $cidx1 + 1
  #  let cidx3 = $cidx2 + 1
  #  let cidx4 = $cidx3 + 1
  #  let credenitalsection = ( open "/Users/ivarbj/.aws/credentials" | lines | enumerate | select $cidx0 $cidx1 $cidx2 $cidx3 $cidx4 )

  load-env {
    "AWS_REGION": $region,
    "AWS_PROFILE": $profile,
    "AWS_DEFAULT_REGION": $region,
    "AWS_SDK_LOAD_CONFIG": "1",
    #    "AWS_ACCESS_KEY_ID": (( $credenitalsection | find aws_access_key_id | get item ).0 | split row "=" ).1,
    #    "AWS_SESSION_TOKEN": (( $credenitalsection | find aws_session_token | get item ).0 | split row "=" ).1,
    #    "AWS_SECRET_ACCESS_KEY": (( $credenitalsection | find aws_secret_access_key | get item ).0 | split row "=" ).1,
    "KUBECONFIG": $"/Users/ivarbj/.kube/($profile).kube"
  }
  
  print $"Profile switched to ($profile)"
  $env | transpose key value | where ($it.key | str starts-with -i 'aws_' )
  $env | transpose key value | where ($it.key | str starts-with "KUBECONFIG" )

}

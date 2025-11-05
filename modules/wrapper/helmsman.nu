export def --wrapped helm [...args] {
  let nojson = ["--help" "help" "pull" "push" "update" "verify" "version" "env" "dep" "dependency" "uninstall" "get" "repo"]
  let first = ($args | select 0) | first
  if ( ($first == "ls") or ($first == "list") or ($first == "history") ) {
    ^helm ...$args --output json 
    | from json 
    | update revision {$in | into int } 
    | update updated {$in | str replace "UTC" "" | into datetime --timezone UTC }
  } else if (($nojson | any {|p| $p in $args }) or ($args | is-empty)) {
    ^helm ...$args 
  } else {
    ^helm ...$args --output json
    | from json
  }
}

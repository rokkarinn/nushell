export def --wrapped helm [...args] {
  if (('--help' in $args) or ($args | is-empty)) {
    ^helm ...$args --help
  } else {
    ^helm ...$args --output json
    | from json
  }
}

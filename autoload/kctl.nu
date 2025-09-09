def --wrapped kctl [...rest] {
  kubectl -o json ...$rest
  | from json
  | get items
}

#alias ll = eza -lah
alias ll = ls -la
alias k = kubectl
alias switch = switcher 
alias kns = switcher ns
alias kctx = switcher
alias kubectx = switcher 
alias kubens = switcher ns
alias vim = nvim
let fish_completer = {|spans|
    fish --command $"complete '--do-complete=($spans | str replace --all "'" "\\'" | str join ' ')'"
    | from tsv --flexible --noheaders --no-infer
    | rename value description
    | update value {|row|
      let value = $row.value
      let need_quote = ['\' ',' '[' ']' '(' ')' ' ' '\t' "'" '"' "`"] | any {$in in $value}
      if ($need_quote and ($value | path exists)) {
        let expanded_path = if ($value starts-with ~) {$value | path expand --no-symlink} else {$value}
        $'"($expanded_path | str replace --all "\"" "\\\"")"'
      } else {$value}
    }
}

$env.cofnig.edit_mode = 'vi'

use '/Users/ivarbj/.config/broot/launcher/nushell/br' *

source ~/.cache/carapace/init.nu

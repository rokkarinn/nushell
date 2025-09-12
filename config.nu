
#alias ll = eza -lah
alias ll = ls -la
alias k = kubectl
alias kctx = kubectx 
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


use '/Users/ivarbj/.config/nushell/modules/awsprofile.nu' *
use '/Users/ivarbj/.config/broot/launcher/nushell/br' *
use '/Users/ivarbj/.config/nushell/modules/start_zellij.nu' *
use '/users/ivarbj/.config/nushell/modules/kubens.nu' *

start_zellij

source ~/.cache/carapace/init.nu

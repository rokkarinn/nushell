
#alias ll = eza -lah
alias ll = ls -la
alias k = kubectl
alias kctx = kubectx 
alias vim = nvim
alias brew = arch -arm64 brew
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

use '/Users/ivarbj/.config/nushell/modules/wrapper' *
use '/Users/ivarbj/.config/broot/launcher/nushell/br' *
use '/Users/ivarbj/.config/nushell/modules/kubernetes' *
#use /Users/ivarbj/.config/nushell/nupm/modules/bru/bru 
use /Users/ivarbj/.config/nushell/modules/completion *

source ~/.zoxide.nu


## custom completions
use '/Users/ivarbj/.config/nushell/custom_completions/make-completions.nu' *
use '/Users/ivarbj/.asdf/completions/nushell.nu' *
## 

start_zellij

use nupm/nupm

# Themes
source ./themes/tokyonight/tokyonight.nu

source ~/.cache/carapace/init.nu

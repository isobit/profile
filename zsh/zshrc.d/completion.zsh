fpath=($fpath ~/.zsh-functions)
autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete

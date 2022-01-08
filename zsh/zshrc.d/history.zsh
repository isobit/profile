export HISTFILE="${HOME}/.zsh-history"
export HISTSIZE=1000000
export SAVEHIST=1000000

setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_verify
setopt share_history

bindkey '^R' history-incremental-search-backward

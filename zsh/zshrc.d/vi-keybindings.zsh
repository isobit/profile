if [[ "$ZSH_VI_MODE" = true ]]; then
	# Enable vi keybindings
	bindkey -v

	# Reduce vi mode switching delay
	export KEYTIMEOUT=1

	# vim-like backspace
	bindkey "^?" backward-delete-char

	# ctrl-r for backward search
	bindkey '^r' history-incremental-search-backward

	# v to edit command line in editor
	autoload -Uz edit-command-line
	zle -N edit-command-line
	bindkey -M vicmd v edit-command-line

	# Right prompt indicator for vi mode
	precmd() { RPROMPT="" }
	function zle-line-init zle-keymap-select {
		VI_MODE_PROMPT='%{$fg_bold[yellow]%}[NORMAL]%{$reset_color%}'
		RPS1="${${KEYMAP/vicmd/$VI_MODE_PROMPT}/(main|viins)/}"
		zle reset-prompt
	}
	zle -N zle-line-init
	zle -N zle-keymap-select
fi

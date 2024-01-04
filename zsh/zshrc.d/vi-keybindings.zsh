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
fi

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
	# Use vertical cursor when in insert mode, block when in normal mode

	if [[ "$TERM" =~ "screen.*" ]]; then
		local cursor_esc_block="\eP\e[1 q\e\\"
		local cursor_esc_line="\eP\e[5 q\e\\"
	elif [[ "$TERM_PROGRAM" =~ "iTerm.*" ]]; then
		local cursor_esc_block="\E]50;CursorShape=0\C-G"
		local cursor_esc_line="\E]50;CursorShape=1\C-G"
	else
		local cursor_esc_block="\E[1 q"
		local cursor_esc_line="\E[5 q"
	fi

	function zle-keymap-select zle-line-init {
		case "$KEYMAP" in
			vicmd)      print -n -- "$cursor_esc_block";;
			viins|main) print -n -- "$cursor_esc_line";;
		esac
		zle reset-prompt
		zle -R
	}
	zle -N zle-line-init
	zle -N zle-keymap-select

	function zle-line-finish {
		print -n -- "$cursor_esc_block"
	}
	zle -N zle-line-finish
fi

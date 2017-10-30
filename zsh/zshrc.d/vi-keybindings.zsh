local use_vim_keybindings=false
if $use_vim_keybindings; then
	bindkey -v

	# Reduce vim mode switching delay
	export KEYTIMEOUT=1

	function zle-keymap-select zle-line-init {
		case "$TERM_PROGRAM" in
			"iTerm")
				case "$KEYMAP" in
					vicmd)      print -n -- "\E]50;CursorShape=0\C-G";;  # block cursor
					viins|main) print -n -- "\E]50;CursorShape=1\C-G";;  # line cursor
				esac
				;;
			*)
				case "$KEYMAP" in
					vicmd)      print -n -- "\E[1 q";;  # block cursor
					viins|main) print -n -- "\E[5 q";;  # line cursor
				esac
				;;
		esac

		zle reset-prompt
		zle -R
	}

	function zle-line-finish {
		case "$TERM_PROGRAM" in
			"iTerm")
				print -n -- "\E]50;CursorShape=0\C-G"  # block cursor
				;;
			*)
				print -n -- "\E[1 q"
				;;
		esac
	}

	zle -N zle-line-init
	zle -N zle-line-finish
	zle -N zle-keymap-select
fi

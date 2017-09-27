# Git prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr "%{$fg[green]%}*%{$reset_color%}"
zstyle ':vcs_info:*' unstagedstr "%{$fg[yellow]%}*%{$reset_color%}"
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' actionformats "%{$fg_bold[grey]%}[%{$fg_bold[red]%}%b%c%u%a%{$reset_color%}%{$fg_bold[grey]%}] "
zstyle ':vcs_info:git*' formats "%{$fg_bold[grey]%}[%{$fg_bold[red]%}%b%c%u%{$reset_color%}%{$fg_bold[grey]%}] "
precmd_functions+=(vcs_info)

# Prompt string
setopt prompt_subst
local PROMPT_HOST=''
if [[ ! -f ~/.zsh-prompt-hide-host ]]; then
	local PROMPT_HOST='%{$fg_bold[grey]%}[%{$reset_color%}%{$fg[magenta]%}%n@%M%{$reset_color%}%{$fg_bold[grey]%}]%{$reset_color%} '
fi
local PROMPT_PWD='%{$fg[blue]%}%c%{$reset_color%} '
local PROMPT_GIT='${vcs_info_msg_0_}'
local PROMPT_DELIM='%{$fg_bold[grey]%}>%{$reset_color%} '
PROMPT="$PROMPT_HOST$PROMPT_PWD$PROMPT_GIT$PROMPT_DELIM"

# Title
function title {
	[[ "$EMACS" == *term*  ]] && return

	# if $2 is unset use $1 as default
	#   # if it is set and empty, leave it as is
	: ${2=$1}

	case "$TERM" in
		cygwin|xterm*|putty*|rxvt*|ansi)
			print -Pn "\e]2;$2:q\a" # set window name
			print -Pn "\e]1;$1:q\a" # set tab name
			;;
		screen*)
			print -Pn "\ek$1:q\e\\" # set screen hardstatus
			;;
		*)
			if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
				print -Pn "\e]2;$2:q\a" # set window name
				print -Pn "\e]1;$1:q\a" # set tab name
			else
				# Try to use terminfo to set the title
				# If the feature is available set title
				if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
					echoti tsl
					print -Pn "$1"
					echoti fsl
				fi
			fi
			;;
	esac
}

function prompt_title_precmd {
	title "%15<..<%~%<<" "%n@%m: %~"
}
precmd_functions+=(prompt_title_precmd)

function prompt_title_preexec {
	local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
	local LINE="${2:gs/%/%%}"
	title '%10<..<%~%<<:$CMD' '%100>...>$LINE%<<'
}
preexec_functions+=(prompt_title_preexec)

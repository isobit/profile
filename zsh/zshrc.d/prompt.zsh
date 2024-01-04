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
local PROMPT_HOST='%{$fg_bold[grey]%}[%{$reset_color%}%{$fg[magenta]%}%n@%M%{$reset_color%}%{$fg_bold[grey]%}]%{$reset_color%} '
if [[ "$ZSH_PROMPT_HIDE_HOST" = true ]]; then
	PROMPT_HOST=''
fi
local PROMPT_NIX_SHELL=''
if [[ -v IN_NIX_SHELL ]]; then
	PROMPT_NIX_SHELL="%{$fg_bold[grey]%}[%{$reset_color%}%{$fg[green]%}$IN_NIX_SHELL%{$reset_color%}%{$fg_bold[grey]%}]%{$reset_color%} "
fi
local PROMPT_PWD='%{$fg[blue]%}%c%{$reset_color%} '
local PROMPT_GIT='${vcs_info_msg_0_}'
local PROMPT_DELIM='%{$fg_bold[grey]%}>%{$reset_color%} '
PROMPT="${PROMPT_HOST}${PROMPT_PWD}${PROMPT_GIT}${PROMPT_NIX_SHELL}${PROMPT_DELIM}"

# VI mode indicator
function zle-line-init zle-keymap-select {
	local PROMPT_DELIM='%{$fg_bold[grey]%}>%{$reset_color%} '
	if [[ "$KEYMAP" == "vicmd" ]]; then
		PROMPT_DELIM='%{$fg_bold[yellow]%}N%{$reset_color%} '
	fi
	PROMPT="${PROMPT_HOST}${PROMPT_PWD}${PROMPT_GIT}${PROMPT_NIX_SHELL}${PROMPT_DELIM}"
	zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select





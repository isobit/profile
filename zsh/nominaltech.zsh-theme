# vim:ft=zsh ts=2 sw=2 sts=2
# NominalTech ZSH Theme

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[yellow]%} ✗%{$fg[black]%}]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[black]%}]"

SEGMENT_SEPARATOR=''

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
	PROMPT="%{$fg[yellow]%}@%m%{$reset_color%} "
else
	PROMPT=""
fi
PROMPT="$PROMPT%{$fg[blue]%}%c %{$fg_bold[grey]%}$(git_prompt_info)%{$fg_bold[grey]%}  %{$reset_color%}"

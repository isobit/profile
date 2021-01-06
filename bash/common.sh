#!/usr/bin/env bash
# Utility functions and aliases for bash and zsh.
# This file is intended to be symlinked to ~/.common.sh and then sourced by
# both bashrc and zshrc.

if [[ "$OSTYPE" =~ "darwin" ]]; then
	alias ls="ls -G"
else
	alias ls="ls --color=auto"
fi

alias trim="sed 's/^ *//;s/ *$//'"
alias dus="du -sh * | sort -h"
alias grep="grep --color=auto"
alias grep-multiline="grep -Pzo"
alias download="curl -fLOJ"
alias datestamp="date -u +'%Y%m%d'"

# shellcheck disable=SC2120
timestamp() {
	local fmt='%Y%m%dT'
	case "${1:l}" in
		-h|--hour)
			fmt+='%H'
			;;
		-m|--min|--minute)
			fmt+='%H%M'
			;;
		''|-s|--sec|--second)
			fmt+='%H%M%S'
			;;
		*)
			echo "Unknown option: ${1}" 1>&2
			echo "Usage: timestamp [OPTION]..." 1>&2
			echo "Print an ISO8601-compatible timestamp for use in filenames." 1>&2
			echo "  -h, --hour           Omit minutes and seconds" 1>&2
			echo "  -m, --min, --minute  Omit seconds" 1>&2
			echo "  -s, --sec, --second  Do not omit anything (the default)." 1>&2
			return 1
	esac
	fmt+='Z'
	date -u +"${fmt}"
}

# Resolve a relative path
path() {
	cd "$(dirname "$1")" || return 1
	echo "$PWD/$(basename "$1")"
}

# Determine if command is available
installed() {
	hash "$1" 2>/dev/null || alias "$1" > /dev/null 2>&1
}

# Use safe-rm if possible, otherwise make rm ask before clobbering a file. Use -f to override.
if installed safe-rm; then
	alias rm="safe-rm -I"
else
	alias rm="rm -I"
fi

# clip alias, should point to clipboard
if installed pbcopy; then
	alias clip=pbcopy
elif installed xclip; then
	alias clip="xclip -selection c"
fi

# Extract function, courtesy of Itai Ferber
extract() {
	local file="${*:-1}"
	if [[ -f "$file" ]]; then
		case "$file" in
			*.tar)      tar -xf "$@"       ;;
			*.tar.gz)   tar -zxf "$@"      ;;
			*.tgz)      tar -zxf "$@"      ;;
			*.tar.xz)   tar -xf "$@"       ;;
			*.txz)      tar -xf "$@"       ;;
			*.tar.bz2)  tar -jxf "$@"      ;;
			*.tbz2)     tar -jxf "$@"      ;;
			*.bz2)      bunzip2 "$@"       ;;
			*.dmg)      hdiutil mount "$@" ;;
			*.gz)       gunzip "$@"        ;;
			*.zip)      unzip "$@"         ;;
			*.Z)        uncompress "$@"    ;;
			*)          echo "'${file}' cannot be extracted/mounted via extract()." ;;
		esac
	else
		echo "'${file}' is not a valid file."
	fi
}

if installed pigz; then
	alias tar-gz="tar -I pigz"
else
	alias tar-gz="tar -z"
fi

if installed pxz; then
	alias tar-xz="tar -I pxz"
else
	alias tar-xz="tar -J"
fi

export BACKUP_DIR="$HOME/backup/"
backup() {
	local file
	file="$(path "$1")"
	tar-xz -cf "$BACKUP_DIR/${file//\//%}_$(timestamp).tar.gz" "${@:2}" "$1"
}

tarball() {
	tar-gz -cf "${2:-$(basename "$1")}.tar.gz" "$1"
}

tarball-xz() {
	tar-xz -cf "${2:-$(basename "$1")}.tar.xz" "$1"
}

git-tarball() {
	git archive --format=tar.gz HEAD "$1" > "${1}.tar.gz"
}

# SSH with automatic screen session resume
sshs() {
	ssh "$@" -t 'screen -dRR'
}

ssh-fix-permissions() {
	chmod g-w ~
	if [[ -d ~/.ssh ]]; then
		chmod 700 ~/.ssh
	fi
	if [[ -f ~/.ssh/authorized_keys ]]; then
		chmod 600 ~/.ssh/authorized_keys
	fi
	if [[ -f ~/.ssh/id_rsa ]]; then
		chmod 600 ~/.ssh/id_rsa
	fi
	if [[ -f ~/.ssh/id_rsa.pub ]]; then
		chmod 600 ~/.ssh/id_rsa.pub
	fi
}

rgr() {
	if [ $# -lt 2 ]
	then
		echo "rg with interactive text replacement"
		echo "Usage: rgr text replacement-text"
		return
	fi
	vim --clean -c ":execute ':argdo %s%$1%$2%gc | update' | :q" -- "$(rg "$1" -l "${@:3}")"
}

docker-debug() {
	docker run -it --rm --user root --entrypoint '/bin/sh' "$@"
}
docker-sh() {
	docker run -it --rm --entrypoint '/bin/sh' "$@"
}
docker-bash() {
	docker run -it --rm --entrypoint '/bin/bash' "$@"
}
docker-image-size() {
	docker image inspect "$1" --format '{{.Size}}' | numfmt --to iec-i --suffix B
}

wget-site() {
	wget -H -E -k -p "$1"
}

git-bigfiles() {
	local output size size_compressed sha loc
	output='Size (KiB),Size compressed (KiB),SHA-1,Path'
	while IFS=$'\n' read -r y; do
		size="$(( $(echo "$y" | cut -f 5 -d ' ') / 1024 ))"
		size_compressed="$(( $(echo "$y" | cut -f 6 -d ' ') / 1024 ))"
		sha="$(echo "$y" | cut -f 1 -d ' ')"
		loc="$(git rev-list --all --objects | grep "$sha" | cut -f 2 -d ' ')"
		output="${output}\n${size},${size_compressed},${sha},${loc}"
	done <<< "$(git verify-pack -v .git/objects/pack/pack-*.idx | grep -v chain | sort -k3nr | head)"
	echo -e "$output" | column -t -s ','
}

tmp() {
	dir="${HOME}/tmp/$(datestamp)-$1"
	mkdir "$dir"
	pushd "$dir" || return 1
}

# Rebuild & upgrade NixOS, do a nix-env update, and collect garbage.
nixos-upgrade() {
	sudo nixos-rebuild switch --upgrade
	nix-env -u
	# sudo nix-collect-garbage --delete-older-than 30d
	sudo nix-collect-garbage
}

nix-search() {
	nix-env -qaP ".*$1.*"
}

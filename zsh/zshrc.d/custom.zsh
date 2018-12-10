alias trim="sed 's/^ *//;s/ *$//'"
alias dus="du -sh * | sort -h"
alias grep="grep --color=auto"
alias grep-multiline="grep -Pzo"
alias datestamp="date -u +'%Y%m%d'"
alias download="curl -fLOJ"

# alias timestamp="date -u +'%Y%m%dT%H%M%SZ'"
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
	cd "$(dirname $1)"
	echo "$PWD/$(basename $1)"
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

# Compile .java, then run its .class
runjava() {
	javac -g "${1}.java"
	java "$1"
}

# Extract function, courtesy of Itai Ferber
extract() {
	local file="${@: -1}"
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

export BACKUP_DIR="$HOME/backup/"
backup() {
	local file="$(path $1)"
	tar -czf "$BACKUP_DIR/${file//\//%}_$(timestamp).tar.gz" ${@:2} $1
}

tarball() {
	local file="${@: -1}"
	tar -cz "$@" -f "${file}.tar.gz"
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

rsyncd-auto() {
	watch -n 1 "rsync -rtv --exclude .git/ --del '$1' '$2'"
}

srp() {
	echo "s/${1}/${2}/gc"
	for f in $(grep -rl --exclude-dir=".git" --exclude-dir="node_modules" "$1" .); do
		vim "$f" -u NONE -c "%s/${1}/${2}/gc" -c "wq"
	done
}

vimgrep() {
	echo "s/${1}/${2}/gc"
	for f in $(grep -rl --exclude-dir=".git" "$1" .); do
		vim "$f" -c "execute \"normal /${1}\\<CR>\""
	done
}

upload() {
	if ! installed curl; then
		echo "ERROR: curl must be installed"
		return 1
	fi

	local file="$1"
	local should_rm=false
	if [[ -d "$file" ]]; then
		local file="/tmp/${1}.tar.gz"
		tar -cvzf "$file" "$1"
		should_rm=true
	elif [[ ! -f "$file" ]]; then
		echo "ERROR: ${file} is not a file or directory"
		return 1
	fi

	local filename="$2"
	if [[ ! -n "$filename" ]]; then
		local filename="$(basename "$file")"
	fi
	local filename="${filename%%.*}-$(timestamp).${filename#*.}"

	local upload_url="https://fm.isobit.io/webdav/public/${filename}"
	local download_url="https://f.isobit.io/${filename}"

	curl -T "$file" -u "admin" "$upload_url"
	echo

	echo "$download_url"

	if installed clip; then
		printf "$download_url" | clip
	else
		echo "WARNING: could not copy to clipbord"
	fi

	if $should_rm; then
		rm -rf "$file"
	fi
}

# Docker utils

docker-debug() {
	docker run -it --rm --user root --entrypoint '/bin/bash' $@
}

alias dus="du -sh * | sort -h"
alias grep="grep --color=auto"
alias grep-multiline="grep -Pzo"

# Resolve a relative path
function path {
	cd $(dirname $1)
	echo $PWD/$(basename $1)
}

# Determine if command is available
function installed {
	hash $1 2>/dev/null || alias $1 > /dev/null 2>&1
}

# Use safe-rm if possible, otherwise make rm ask before clobbering a file. Use -f to override.
if installed safe-rm; then
	alias rm="safe-rm -ri"
else
	alias rm="rm -ri"
fi

# clip alias, should point to clipboard
if installed pbcopy; then
	alias clip=pbcopy
elif installed xclip; then
	alias clip='xclip -selection c'
fi

# Compile .java, then run its .class
function runjava {
	javac -g $1.java;
	java $1;
}

# Extract function, courtesy of Itai Ferber
function extract {
	if [ -f $1 ]; then
		case $1 in
			*.tar.bz2)  tar -jxf $1        ;;
			*.tar.gz)   tar -zxf $1        ;;
			*.tar.xz)   tar -xf $1         ;;
			*.bz2)      bunzip2 $1          ;;
			*.dmg)      hdiutul mount $1    ;;
			*.gz)       gunzip $1           ;;
			*.tar)      tar -xf $1         ;;
			*.tbz2)     tar -jxf $1        ;;
			*.tgz)      tar -zxf $1        ;;
			*.zip)      unzip $1            ;;
			*.Z)        uncompress $1       ;;
			*)          echo "'$1' cannot be extracted/mounted via extract()." ;;
		esac
	else
		echo "'$1' is not a valid file."
	fi
}

export BACKUP_DIR="$HOME/backup/"
function backup {
	local file="$(path $1)"
	tar -czf "$BACKUP_DIR/${file//\//%}_$(date +'%Y-%m-%dT%H-%M-%S').tar.gz" ${@:2} $1
}

# Package tar function
function tarball {
	tar -czf $1.tar.gz ${@:2} $1
}
function git-tarball {
	# Create a tarball
	git archive --format=tar.gz HEAD $1 > $1.tar.gz
}

function sshs {
	# SSH with automatic screen session resume
	ssh $@ -t 'screen -dRR'
}

function rsyncd-auto {
	watch -n 1 "rsync -rtv --exclude .git/ --del '$1' '$2'"
}

function srp {
	echo "s/$1/$2/gc"
	for f in $(grep -rl --exclude-dir=".git" --exclude-dir="node_modules" "$1" .); do
		vim $f -u NONE -c "%s/$1/$2/gc" -c "wq"
	done
}

function vimgrep {
	echo "s/$1/$2/gc"
	for f in $(grep -rl --exclude-dir=".git" "$1" .); do
		vim $f -c "execute \"normal /$1\\<CR>\""
	done
}

function upload {
	if ! installed curl; then
		echo "ERROR: curl must be installed"
		return 1
	fi

	local file="$1"
	local should_rm=false
	if [ -d "$file" ]; then
		local file="/tmp/$1.tar.gz"
		tar -cvzf $file $1
		should_rm=true
	elif [ ! -f $file ]; then
		echo "ERROR: $file is not a file or directory"
		return 1
	fi

	local filename="$2"
	if [ ! -n "$filename" ]; then
		local filename="$(basename "$file")"
	fi

	local upload_url="https://fm.isobit.io/webdav/$filename"
	local download_url="https://f.isobit.io/$filename"

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

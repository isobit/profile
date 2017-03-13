alias ls="ls --color"

alias dus="du -h -d 1 | sort -h"

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
			*.tar.bz2)  tar -jxvf $1        ;;
			*.tar.gz)   tar -zxvf $1        ;;
			*.tar.xz)   tar -xvf $1         ;;
			*.bz2)      bunzip2 $1          ;;
			*.dmg)      hdiutul mount $1    ;;
			*.gz)       gunzip $1           ;;
			*.tar)      tar -xvf $1         ;;
			*.tbz2)     tar -jxvf $1        ;;
			*.tgz)      tar -zxvf $1        ;;
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
	tar cvzf "$BACKUP_DIR/${1}_$(date +'%Y-%m-%dT%H-%M-%S').tar.gz" ${@:2} $1
}

# Package tar function
function tarball {
	tar cvzf $1.tar.gz ${@:2} $1
}
function git-tarball {
	git archive --format=tar.gz HEAD $1 > $1.tar.gz
}

function fileio {
	if installed curl; then
		should_rm=false
		if [ -d $1 ]; then
			filename="/tmp/$1.tar.gz"
			tar -cvzf $filename $1
			should_rm=true
		elif [ -f $1 ]; then
			filename=$1
		else
			echo "ERROR: $1 is not a file or directory"
			return 1
		fi
		if installed jq; then
			link=$(curl -F "file=@$filename" 'https://file.io/?expires=1d' | jq '.link' -j)
			#filename=$(basename "$1")
			#result="curl '$link' > $filename"
			result=$link
			if installed clip; then
				printf $result | clip
			else
				echo "WARNING: could not copy to clipbord"
			fi
			echo $result
		else
			echo "WARNING: could not parse response, please install jq"
			curl -F "file=@$filename" 'https://file.io/?expires=1d'
		fi
		if $should_rm; then
			rm -rf $filename
		fi
	else
		echo "ERROR: curl must be installed"
		return 1
	fi
}

function sshs {
	ssh $@ -t 'screen -dRR'
}

function rsyncd-auto {
	watch -n 1 "rsync -rtv --exclude .git/ --del '$1' '$2'"
}

function srp {
	echo "s/$1/$2/gc"
	for f in $(grep -rl --exclude-dir=".git" "$1" .); do
		vim $f -u NONE -c "%s/$1/$2/gc" -c "wq"
	done
}

function vimgrep {
	echo "s/$1/$2/gc"
	for f in $(grep -rl --exclude-dir=".git" "$1" .); do
		vim $f -c "execute \"normal /$1\\<CR>\""
	done
}

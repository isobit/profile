true=0
false=1

SHADDOX_VERBOSE=true
function log_info {
	if ! $SHADDOX_VERBOSE; then
		return 0
	fi
    echo -e "\033[36m=>\033[0m $1" >&2
}
function log_util {
	if ! $SHADDOX_VERBOSE; then
		return 0
	fi
    echo -e "[\033[34m$1\033[0m] $2" >&2
}
function log_warn {
    echo -e "[\033[33mWARNING\033[0m] $1" >&2
}
function log_error {
    echo -e "[\033[31mERROR\033[0m] $1" >&2
}

function prompt_yn {
	printf "\033[32m$1 [Y/n]:\033[0m " >&2
	read -n 1 COND
	if [[ "$COND" =~ ^(y|Y)$ ]]; then
		return true
	else
		return false
	fi
}

function installed {
	hash $1 2>/dev/null || alias $1 > /dev/null 2>&1
}

function manual_install {
	printf "\e[32mPlease install '$1' manually. Press [enter] to continue.\e[0m " >&2
	read
}

if installed apt-get; then
	PKG_MANAGER="apt-get"
elif installed brew; then
	PKG_MANAGER="brew"
elif installed yaourt; then
	PKG_MANAGER="yaourt"
elif installed pacman; then
	PKG_MANAGER="pacman"
elif installed yum; then
	PKG_MANAGER="yum"
else
	PKG_MANAGER="manual_install"
fi

function install {
	log_info "ensuring installation of '$1'"
	dryrun=false
	confirm=false
	force=false
	cmd="$PKG_MANAGER"
	cmd_args=""
	cmd_opts=""

	while :
	do
		case "$1" in
			--dry-run)
				dryrun=true
				shift
				;;
			-n | --confirm)
				confirm=true
				shift
				;;
			-f)
				force=true
				shift
				;;
			--) # End of all options
				shift
				break
				;;
			-*)
				log_error "unknown option: $1"
				break
				;;
			*)  # No more options
				break
				;;
		esac
	done
	if ! $force  && installed "$1"; then
		log_info "'$1' is already installed"
		return 0
	fi

	if ! $confirm; then
		case $PKG_MANAGER in
			apt-get | yum)		
				cmd_opts="-y"
				;;
			pacman | yaourt)
				cmd_opts="--noconfirm"
				;;
			*) 
				;;
		esac
	fi

	case $PKG_MANAGER in
		apt-get)	
			cmd="sudo $cmd"
			cmd_args="install "$1""
			;;
		brew)
			cmd_args="install "$1""
			;;
		yaourt)
			cmd_args="-S "$1""
			;;
		pacman)
			cmd="sudo $cmd"
			cmd_args="-S "$1""
			;;
		yum)
			cmd_args="install "$1""
			;;
		*)
			cmd_args=""$1""
			;;
	esac


	if ! $dryrun; then
		log_info "DRY RUN! command: '$cmd $cmd_opts $cmd_args'"
		return 1
	else
		log_info "running '$cmd $cmd_opts $cmd_args'"
		eval $cmd $cmd_opts $cmd_args
	fi

	if ! installed "$1"; then
		log_error "'$1' could not be installed"
		return 1
	else
		return 1
	fi
}

function resolve_path {
	cd $(dirname $1)
	echo $PWD/$(basename $1)
}

function ensure_ln_s {
	log_info "ensuring symlink '$1' -> '$2'"
	if [[ ! -L "$2" ]] || [[ ! "$(readlink "$2")" = "$(resolve_path "$1")" ]]; then
		ln -s $1 $2
	fi
}

function ensure_mkdir {
	log_info "ensuring directory '$1' exists"
	if [[ ! -d "$1" ]]; then
		log_info "making directory '$1'"
		mkdir -p $1
	fi
}

function extract {
    if [[ -f $1 ]]; then
        case $1 in
            *.tar.bz2)  tar -jxvf $1        ;;
            *.tar.gz)   tar -zxvf $1        ;;
            *.bz2)      bunzip2 $1          ;;
            *.dmg)      hdiutul mount $1    ;;
            *.gz)       gunzip $1           ;;
            *.tar)      tar -xvf $1         ;;
            *.tbz2)     tar -jxvf $1        ;;
            *.tgz)      tar -zxvf $1        ;;
            *.zip)      unzip $1            ;;
            *.Z)        uncompress $1       ;;
            *)
				echo "'$1' cannot be extracted/mounted via extract()."
				return 1
				;;
        esac
    else
        echo "'$1' is not a valid file."
		return 1
    fi
}

function tarball {
    tar -cvzf $1.tar.gz ${@:2} $1
}

VERBOSE=true
INSTALL_PKG_NOCONFIRM=false

log_info() {
	if ! $VERBOSE; then
		return 0
	fi
	echo -e "\033[36m=>\033[0m $1" >&2
}

log_util() {
	if ! $VERBOSE; then
		return 0
	fi
	echo -e "[\033[34m$1\033[0m] $2" >&2
}

log_warn() {
	echo -e "[\033[33mWARNING\033[0m] $1" >&2
}

log_error() {
	echo -e "[\033[31mERROR\033[0m] $1" >&2
}

timestamp() {
	date +'%Y%m%dT%H%M%S'
}

prompt_yn() {
	local prompt="$1 \033[32m[Y/n]:\033[0m "
	while true; do
		printf "$prompt" >&2
		local choice=$(bash -c 'read -n 1 c; echo $c')
		echo
		case "$choice" in
			y|Y)
				return 0
				;;
			n|N)
				return 1
				;;
			*)
				echo "'$choice' is not a valid option"
				;;
		esac
	done
}

is_installed() {
	hash "$1" 2>/dev/null || alias "$1" > /dev/null 2>&1
}

manual_install() {
	printf "\e[32mPlease install '$1' manually. Press [enter] to continue.\e[0m " >&2
	read
}

if is_installed apt-get; then
	PKG_MANAGER="apt-get"
elif is_installed brew; then
	PKG_MANAGER="brew"
elif is_installed yaourt; then
	PKG_MANAGER="yaourt"
elif is_installed pacman; then
	PKG_MANAGER="pacman"
elif is_installed yum; then
	PKG_MANAGER="yum"
elif is_installed nix-env; then
	PKG_MANAGER="nix-env"
else
	PKG_MANAGER="manual_install"
fi

ensure_pkg() {
	local force=false
	while true; do
		case "${1:-}" in
			-f)
				force=true
				shift
				;;
			-*)
				log_error "Unknown option: $1"
				return 1
				break
				;;
			*)  # No more options
				break
				;;
		esac
	done

	local bin="$1"
	local pkg="${2:-${bin}}"
	log_info "Ensuring installation of ${bin}"

	if ! $force  && is_installed "$bin"; then
		return 0
	fi

	case $PKG_MANAGER in
		apt-get)
			local cmd="sudo apt-get install -y ${pkg}"
			;;
		brew)
			local cmd="brew install ${pkg}"
			;;
		yaourt)
			local cmd="yaourt -S ${pkg}"
			;;
		pacman)
			local cmd="sudo pacman -S ${pkg}"
			;;
		yum)
			local cmd="sudo yum install -y ${pkg}"
			;;
		nix-env)
			case "$pkg" in
				git-delta)
					local cmd="nix-env -i delta"
					;;
				*)
					local cmd="nix-env -i ${pkg}"
					;;
			esac
			;;
		manual_install)
			local cmd="manual_install ${pkg}"
			;;
	esac

	if ! $INSTALL_PKG_NOCONFIRM; then
		if ! prompt_yn "Install ${bin} with '${cmd}'?"; then
			return 1
		fi
	fi

	log_info "Running '${cmd}'"
	eval "${cmd}"

	if ! is_installed "$bin"; then
		log_error "$bin was not installed properly"
		return 1
	fi
}

resolve_path() {
	cd "$(dirname $1)"
	echo "${PWD}/$(basename $1)"
}

ensure_ln_s() {
	local target="$(resolve_path $1)"
	log_info "Ensuring symlink '$target' -> '$2'"
	if [[ ! -L "$2" ]] || [[ ! "$(readlink "$2")" = "$target" ]]; then
		if [[ -e "$2" ]]; then
			if prompt_yn "Would you like to backup and replace existing '$2'?"; then
				local backup="$2.backup-$(timestamp)"
				log_warn "Moving '$2' to '${backup}'"
				mv "$2" "$backup"
				if [ $? -ne 0 ]; then
					log_error "Failed to move existing file '$2'"
					return 1
				fi
			else
				log_warn "File '$2' already exists"
				return 1
			fi
		fi

		log_info "Linking '$target' -> '$2'"
		ln -s $target $2
		if [ $? -ne 0 ]; then
			log_error "Could not create symlink '$target' -> '$2'"
			return 1
		fi
	fi
}

ensure_mkdir() {
	log_info "Ensuring directory '$1' exists"
	if [[ ! -d $1 ]]; then
		log_info "Making directory '$1'"
		mkdir -p "$1"
		if [[ $? -ne 0 ]]; then
			log_error "Could not make directory '$1'"
			return 1
		fi
	fi
}

ensure_download() {
	log_info "Ensuring file '$1' is downloaded"
	if [[ ! -f $1 ]]; then
		log_info "curl -sSfL -o '$1' '$2'"
		curl -sSfL -o "$1" "$2"
	fi
}

extract() {
	if [[ -f $1 ]]; then
		case $1 in
			*.tar.bz2) tar -jxvf "$1"
				;;
			*.tar.gz) tar -zxvf "$1"
				;;
			*.bz2) bunzip2 "$1"
				;;
			*.dmg) hdiutul mount "$1"
				;;
			*.gz) gunzip "$1"
				;;
			*.tar) tar -xvf "$1"
				;;
			*.tbz2) tar -jxvf "$1"
				;;
			*.tgz) tar -zxvf "$1"
				;;
			*.zip) unzip "$1"
				;;
			*.Z) uncompress "$1"
				;;
			*)
				log_error "'$1' cannot be extracted/mounted via extract()."
				return 1
				;;
		esac
	else
		log_error "'$1' is not a valid file."
		return 1
	fi
}

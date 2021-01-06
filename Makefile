.PHONY: check
check:
	shellcheck -e SC1090 -e SC1091 sh/profile bash/bash_login bash/bashrc bash/common.sh

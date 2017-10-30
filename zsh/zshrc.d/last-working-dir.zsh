last_working_dir_chpwd() {
	pwd > "${HOME}/.zsh-last-working-dir"
}
chpwd_functions+=(last_working_dir_chpwd)

if [[ "$PWD" == "$HOME" && -r "${HOME}/.zsh-last-working-dir" ]]; then
	cd "$(cat "${HOME}/.zsh-last-working-dir")"
fi

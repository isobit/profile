# profile

Repository for dotfiles, configs, and general user/home environment on *nix
systems.

## Installation

Run `./install` in the repo directory. Everything is installed relative to
`$HOME`, regardless of the checkout location of this repo.

### ZSH Configuration

ZSH configuration should automatically be populated into `${HOME}/.zshenv`, if
that file does not exist already.

### Mapping Caps Lock to Escape

- **GNOME**: Use the tweak tool keyboard settings.
- **macOS**: Use [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements).
- **Windows**: Get [AutoHotkey](http://www.autohotkey.com/) and use the script `Capslock::Esc`.

## Usage

### Host-specifc Config

Local configuration will be sourced from the following locations:

- **All POSIX shells**: `~/.profile.local` (mainly for env vars and PATH
	changes)
- **zsh**: `~/.zshrc.local` (also `~/.localrc` for backwards compatibility with
	older versions of this repo)
- **vim**: `~/.vimrc.local`


## Where to put shell config

1. Environment variable exports, `PATH` modifications, and settings that are
   _inherited_ by processes and are applicable to all POSIX-compatible shells
   go in `sh/profile`.
2. Aliases and custom/utility functions for both bash and zsh go in
   `bash/common.sh`.
3. Bash-specific config belongs in `bash/bashrc`, zsh-specific config belongs
   in `zsh/zshrc`.

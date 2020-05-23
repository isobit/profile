# profile

Repository for dotfiles, configs, and general user/home environment on *nix
systems.

## Installation

Run `./install` in the repo directory. Everything is installed relative to `$HOME`.

### ZSH Configuration

ZSH configuration should automatically be populated into `${HOME}/.zshenv`, if that
file does not exist already.

### Mapping Caps Lock to Escape

- **GNOME**: Use the tweak tool keyboard settings.
- **macOS**: Use [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements).
- **Windows**: Get [AutoHotkey](http://www.autohotkey.com/) and use the script `Capslock::Esc`.

## Usage

### Host-specifc Config

Local configuration will be sourced from the following locations:

- **zsh**: `${HOME}/.zshrc.local`, `${HOME}/.localrc`
- **vim**: `${HOME}/.vimrc.local`

profile
=======

## Installation

Run `./install` in the repo directory. Everything is installed relative to `~`.

### ZSH Configuration

ZSH configuration should automatically be populated into `~/.zshenv`, if that
file does not exist already.

### Mapping Caps Lock to Escape

- **GNOME**: Use the tweak tool keyboard settings.
- **macOS**: Use [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements).
- **Windows**: Get [AutoHotkey](http://www.autohotkey.com/) and use the script `Capslock::Esc`.

## Usage

### Local Config

System-local configuration will be sourced from the following locations:
- **zsh**: `~/.zshrc.local`, `~/.localrc`
- **vim**: `~/.vimrc.local`

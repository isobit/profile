profile
=======

## Installation

Run `./install` in the repo directory. Everything is installed relative to `~`.

### Local Config
System-local configuration will be sourced from the following locations:
- zsh: `~/.zshrc.local`, `~/.localrc`
- vim: `~/.vimrc.local`

### Mapping Caps Lock to Escape

#### Windows

Get [AutoHotkey](http://www.autohotkey.com/) and use the script `Capslock::Esc`.

#### Antergos

Look in the keyboard settings.

#### Mac

Use [Karabiner-Elements](https://github.com/tekezo/Karabiner-Elements).

## Usage

Put any machine-specific `zshrc` commands in `~/.localrc`. It will be sourced automatically by `~/.zshrc`.

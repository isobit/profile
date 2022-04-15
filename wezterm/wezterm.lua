local w = require('wezterm')
return {
  check_for_updates = false,
  enable_wayland = true,
  exit_behavior = "Close",

  color_scheme = "Builtin Tango Dark",
  font = w.font("Fira Code"),
  font_size = 11,

  keys = {
    {key="c", mods="ALT", action=w.action{CopyTo="Clipboard"}},
    {key="v", mods="ALT", action=w.action{PasteFrom="Clipboard"}},
    {key="t", mods="ALT", action=w.action{SpawnTab="CurrentPaneDomain"}},
    {key="[", mods="ALT", action=w.action{ActivateTabRelative=-1}},
    {key="{", mods="ALT", action=w.action{MoveTabRelative=-1}},
    {key="]", mods="ALT", action=w.action{ActivateTabRelative=1}},
    {key="}", mods="ALT", action=w.action{MoveTabRelative=1}},
  },
}

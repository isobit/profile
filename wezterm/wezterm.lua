local w = require('wezterm')
return {
  check_for_updates = false,
  enable_wayland = true,
  exit_behavior = "Close",

  font = w.font("Fira Code"),
  font_size = 11,

  color_scheme = "Builtin Tango Dark",
  colors = {
    tab_bar = {
      background = "#111",
      active_tab = {
        bg_color = "#333",
        fg_color = "#EEE",
      },
      inactive_tab = {
        bg_color = "#222",
        fg_color = "#EEE",
      },
      new_tab = {
        bg_color = "#111",
        fg_color = "#EEE",
      },
      new_tab_hover = {
        bg_color = "#333",
        fg_color = "#EEE",
      },
    },
  },
  window_frame = {
    active_titlebar_bg = "#111",
    inactive_titlebar_bg = "#111",
    active_titlebar_border_bottom = "#111",
    inactive_titlebar_border_bottom = "#111",
    button_bg = "#222",
    button_hover_bg = "#333",
  },

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

local w = require('wezterm')
return {
	-- this fixes broken text on NixOS
	front_end = "WebGpu",
	webgpu_power_preference = 'HighPerformance',

	check_for_updates = false,
	exit_behavior = "Close",

	audible_bell = "Disabled",

	font = w.font("Fira Code"),
	font_size = 12,
	warn_about_missing_glyphs = false,

	color_scheme = "Builtin Tango Dark",

	use_fancy_tab_bar = false;
	colors = {
		tab_bar = {
			background = "#191919",
			active_tab = {
				bg_color = "#445",
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
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},

	keys = {
		{key="c", mods="ALT", action=w.action{CopyTo="Clipboard"}},
		{key="v", mods="ALT", action=w.action{PasteFrom="Clipboard"}},
		{key="t", mods="ALT", action=w.action{SpawnTab="CurrentPaneDomain"}},
		{key="[", mods="ALT", action=w.action{ActivateTabRelative=-1}},
		{key="{", mods="ALT|SHIFT", action=w.action{MoveTabRelative=-1}},
		{key="]", mods="ALT", action=w.action{ActivateTabRelative=1}},
		{key="}", mods="ALT|SHIFT", action=w.action{MoveTabRelative=1}},
	},
}

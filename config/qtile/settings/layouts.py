from libqtile import layout


layout_opts = {
    "border_width": 1,
    "margin":  8,
    "rounded":  True,
}

layouts = [
    layout.Columns(**layout_opts),
    layout.Max(**layout_opts),
]

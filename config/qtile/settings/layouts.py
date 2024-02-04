from libqtile import layout


layout_opts = {
    "border_focus_stack": ["#d75f5f", "#8f3d3d"],
    "border_width": 2,
    "margin":  4,
}

layouts = [
    layout.Columns(**layout_opts),
    layout.Max(**layout_opts),
    # Try more layouts by unleashing below layouts.
    # layout.MonadTall(),
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

from libqtile import bar, widget
from libqtile.widget import Sep
from libqtile.config import Screen

wallpaper_path = "/home/cacarico/Pictures/Wallpapers/current"
background_color = "#6B20786B"

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.Clock(format="%b %d %Y %a"),
                Sep(
                    linewidth = 0,
                    padding = 6
                    ),
                widget.GroupBox(),
                Sep(
                    linewidth = 0,
                    padding = 6
                    ),
                widget.Backlight(
                    brightness_file='/sys/class/backlight/amdgpu_bl1/brightness',
                    max_brightness_file='/sys/class/backlight/amdgpu_bl1/max_brightness',
                    scroll=True
                    ),
                widget.Battery(format="{percent:2.0%}"),
                widget.Clock(format="%b %d %Y %a %I:%M %p"),
            ],
            24,
            background=background_color,
        ),
        wallpaper=wallpaper_path,
        wallpaper_mode='fill',
        x11_drag_polling_rate = 60,
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
            ],
            24,
            background=background_color,
        ),
        wallpaper=wallpaper_path,
        wallpaper_mode='fill',
        x11_drag_polling_rate = 60,
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
            ],
            24,
            background=background_color,
        ),
        wallpaper=wallpaper_path,
        wallpaper_mode='fill',
        x11_drag_polling_rate = 60,
    ),
]

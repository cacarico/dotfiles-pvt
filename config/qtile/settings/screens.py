from libqtile import bar, widget
from libqtile.widget import Sep
from libqtile.config import Screen

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
            background="#6B20786B",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        wallpaper='/home/cacarico/Pictures/Wallpapers/current',
        wallpaper_mode='fill',


        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        x11_drag_polling_rate = 60,
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
            ],
            24,
            background="#6B20786B",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        wallpaper_mode='fill',


        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        x11_drag_polling_rate = None,
    ),
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
            ],
            24,
            background="#6B20786B",
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
        wallpaper_mode='fill',


        # You can uncomment this variable if you see that on X11 floating resize/moving is laggy
        # By default we handle these events delayed to already improve performance, however your system might still be struggling
        # This variable is set to None (no cap) by default, but you can set it to 60 to indicate that you limit it to 60 events per second
        x11_drag_polling_rate = 60,
    ),
]

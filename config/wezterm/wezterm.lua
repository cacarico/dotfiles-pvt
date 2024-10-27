-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

local font_size = 10
local font_family = 'GoMonoNerdFont'
local background_opacity = 0.5
local format_bg_color = string.format('rgba(%f %f %f %f)', background_opacity, background_opacity, background_opacity, background_opacity)


-- This is where you actually apply your config choices

-- For example, changing the color scheme:
-- config.color_scheme = 'Catppuccin Mocha'

config.window_background_opacity = background_opacity

-- Fonts Configuration
config.font = wezterm.font(font_family)
config.font_size = font_size

-- Bar configuration
config.show_new_tab_button_in_tab_bar = false

config.colors = {
  tab_bar = {
    background = '#0b0022',

    active_tab = {
      bg_color = '#2b2042',
      fg_color = '#c0c0c0',
      intensity = 'Normal',
      underline = 'None',
      italic = false,
      strikethrough = false,
    },

    inactive_tab = {
      bg_color = '#1b1032',
      fg_color = '#808080',
    },

    inactive_tab_hover = {
      bg_color = '#3b3052',
      fg_color = '#909090',
      italic = true,

    },
  },
}

-- Config top bar
config.window_frame = {

  font = wezterm.font { family = font_family, weight = 'Bold' },
  font_size = font_size,
  active_titlebar_bg = format_bg_color,
  inactive_titlebar_bg = '#333333',
}

-- Ensure that the colors table merges correctly with the color scheme
config.colors = config.colors or {}
config.colors.tab_bar = config.colors.tab_bar or {}

return config

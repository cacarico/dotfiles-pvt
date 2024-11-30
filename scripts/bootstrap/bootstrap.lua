#!/usr/bin/env lua

-- Require the luaposix module
local posix = require("posix")

local create_dir = {
	"~/.cache/nvim/undodir",
	"~/.local/share/logs",
	"~/.local/share/waybar",
	"~/.themes",
	"~/Books",
	"~/Games",
	"~/Mounts/usb",
	"~/Music",
	"~/Pictures",
	"~/ghq/github.com/cacarico",
}

local tmp_create_dir = {
	"test",
}

local home_dir = os.getenv("HOME")

-- Function to expand '~'
local function expand_path(path)
	return path:gsub("~", home_dir):gsub("%$(%w+)", os.getenv)
end

-- Iterate over the directories and create them using mkdir
for _, dir in ipairs(tmp_create_dir) do
	local expanded_dir = expand_path(dir)
	-- IMP: Check if the directory already exists
	posix.mkdir(expanded_dir)
end

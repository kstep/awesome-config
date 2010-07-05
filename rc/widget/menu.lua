
local image = image
local theme = require("beautiful")
local menu  = require("rc.menu")

local launcher = require("awful.widget.launcher")

local setmetatable = setmetatable

module("rc.widget.menu")

widget = launcher({ image = image(theme.awesome_icon), menu = menu.mainmenu })

setmetatable(_M, { __call = function(_, ...) return widget end })


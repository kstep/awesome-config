
local progressbar = require("awful.widget.progressbar")
local graph       = require("awful.widget.graph")

local sensual = require("sensual")
local vars = require("rc.vars")

local theme = require("beautiful")

local setmetatable = setmetatable

module("rc.widget.sensor.diskio")

local widgets = {
    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    progressbar({ width = 5, layout = vars.statbox_layout }),
    sensual.label("%.1f %s "),
    sensual.label(" /%3d %s "),

    graph({ width = 30, height = 17, layout = vars.statbox_layout }),
    progressbar({ width = 5, layout = vars.statbox_layout }),
    sensual.label("%.1f %s "),
    sensual.label(" ~%3d %s "),

    layout = vars.statbox_layout
}
widgets[1]:set_max_value(20000)
widgets[5]:set_max_value(20000)

widgets[2]:set_vertical(true)
widgets[6]:set_vertical(true)
widgets[2]:set_height(17)
widgets[6]:set_height(17)

for i = 1,4 do
    widgets[i]:set_color(theme.disk.root)
    widgets[i+4]:set_color(theme.disk.home)
    if i < 3 then
	widgets[i]:set_border_color(theme.disk.root)
	widgets[i+4]:set_border_color(theme.disk.home)
    end
end

regs = {
    sensual.registermore(sensual.dio("sda5"), { widgets[1], widgets[4] }, {
	{ { "sec_read", "sec_write" }, sensual.filters.pipe(sensual.filters.sum, sensual.filters.delta) },
	{ { "bytes_read", "bytes_write" }, sensual.filters.pipe(sensual.filters.sum, sensual.filters.velocity) },
    }, 5),
    sensual.registermore(sensual.dio("sda6"), { widgets[5], widgets[8] }, {
	{ { "sec_read", "sec_write" }, sensual.filters.pipe(sensual.filters.sum, sensual.filters.delta) },
	{ { "bytes_read", "bytes_write" }, sensual.filters.pipe(sensual.filters.sum, sensual.filters.velocity) },
    }, 5),
    sensual.registermore(sensual.statfs("/"), { widgets[2], widgets[3] }, {
	{ "boccup", sensual.filters.scale },
	{ "avail", sensual.filters.humanize },
    }, 27),
    sensual.registermore(sensual.statfs("/home"), { widgets[6], widgets[7] }, {
	{ "boccup", sensual.filters.scale },
	{ "avail", sensual.filters.humanize },
    }, 27)
}

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

setmetatable(_M, { __call = function(_, ...) return get(...) end })


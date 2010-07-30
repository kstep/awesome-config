local capi = { image = image, widget = widget }

local wiout  = require("awful.widget.layout")
local util   = require("awful.util")
local button = require("awful.button")
local theme  = require("beautiful")

local naughty = require("naughty")
local vars = require("rc.vars")
local ipairs = ipairs
local setmetatable = setmetatable

module("rc.widget.cmus")

local widgets = {
    layout = wiout.horizontal.leftright
}

local function cmus_cmd(cmd)
    return function ()
        util.spawn("cmus-remote --" .. cmd) 
    end
end

icons = { "prev", "next", "pause" }
for _, icon in ipairs(icons) do
    widgets[_] = capi.widget({ type = "imagebox" })
    widgets[_].image = capi.image(theme.icons.player[icon])
    widgets[_].resize = false
    widgets[_]:buttons(util.table.join(
        button({}, 1, cmus_cmd(icon))
    ))
end
widgets[4] = capi.widget({ type = "textbox" })
widgets[4].text = "- Сообщений от CMus не было -"

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

function update(data)
    local icons = {
        ["playing"] = theme.icons.player.play,
        ["paused"]  = theme.icons.player.pause,
        ["stopped"] = theme.icons.player.stop,
    }
    local title = data.artist .. ' — «' .. data.title .. '»'
    local img = capi.image(icons[data.status])

    naughty.notify({ timeout = 3, preset = naughty.config.presets.low, icon = img, text = title }) 
    widgets[3].image = img
    widgets[4].text  = title
end

setmetatable(_M, { __call = function (_, ...) return get(...) end })


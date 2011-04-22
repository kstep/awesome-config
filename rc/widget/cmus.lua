local capi = { image = image, widget = widget }

local wiout   = require("awful.widget.layout")
local util    = require("awful.util")
local button  = require("awful.button")
local tooltip = require("awful.tooltip")
local theme  = require("beautiful")

local cmus    = require("sensual.cmus")
local filters = require("sensual.filters")
local naughty = require("naughty")
local vars = require("rc.vars")
local volume = require("rc.widget.sensor.volume")
local ipairs = ipairs
local setmetatable = setmetatable

module("rc.widget.cmus")

local widgets = {
    layout = wiout.horizontal.leftright
}

widgets[1] = capi.widget({ type = "imagebox" })
widgets[1].image = capi.image(theme.icons.player["pause"])
widgets[1].resize = false
widgets[2] = capi.widget({ type = "textbox" })
widgets[2].text = " - Сообщений от CMus не было -"

widgets.buttons = util.table.join(
    button({}, 1, cmus.cmus_cmd("pause")),
    button({}, 3, cmus.cmus_cmd("stop")),
    button({}, 4, cmus.cmus_cmd("prev")),
    button({}, 5, cmus.cmus_cmd("next"))
)

for i = 1,2 do
    widgets[i]:buttons(widgets.buttons)
end

local function icon_by_status(status)
    local icons = {
        ["playing"] = theme.icons.player.play,
        ["paused"]  = theme.icons.player.pause,
        ["stopped"] = theme.icons.player.stop,
    }
    return icons[status]
end

hint = tooltip({
    objects = { widgets[1], widgets[2] },
    timer_function = function ()
        local data = cmus.cmus_query()
        local pos, dur = filters.hms(nil, data.position), filters.hms(nil, data.duration)
        local text = ("%s — «%s» is %s [%02d:%02d/%02d:%02d]\nFile: %s\nRepeat %s\nShuffle is %s"):format(
            data.tag.artist or "Unknown artist",
            data.tag.title or "Unknown title",
            data.status,
            pos[3], pos[4], dur[3], dur[4],
            data.file,
            data.set['repeat_current'] and "current"
                or (data.set['repeat'] and "all" or "none"),
            data.set.shuffle and "on" or "off")
        return text
    end
})

local function get(s)
    return s == vars.widgets_screen and widgets or nil
end

function update(data)
    local title = (" %s — «%s»"):format(data.artist or "Unknown artist", data.title or data.file or "Unknown title")
    local img = capi.image(icon_by_status(data.status))

    volume.headphones_only(true)
    naughty.notify({ timeout = 3, preset = naughty.config.presets.low, icon = img, text = title }) 
    widgets[1].image = img
    widgets[2].text  = title
end

setmetatable(_M, { __call = function (_, ...) return get(...) end })


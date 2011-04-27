
local capi = { widget = widget, dbus = dbus }
local theme = require("beautiful")
local dbus = require("simpledbus")
local button = require("awful.button")
local setmetatable = setmetatable

module("rc.widget.keyboard")

widget = capi.widget({ type = "textbox" })
layouts = { [0] = " En ", [1] = " Ru " }
local function show_layout(layout)
    widget.text = '<span color="#FFFFFF">' .. (layouts[layout] or " ?? ") .. '</span>'
    widget.bg = theme.kbd[layout] or "#000000"
end
show_layout(0)

capi.dbus.request_name("session", "ru.gentoo.kbdd")
capi.dbus.add_match("session", "interface='ru.gentoo.kbdd',member='layoutChanged'")
capi.dbus.add_signal("ru.gentoo.kbdd", function (src, layout)
    show_layout(layout)
end)

local bus = dbus.SessionBus()
function set_layout(layout)
    return bus:call_method('ru.gentoo.KbddService', '/ru/gentoo/KbddService', 'ru.gentoo.kbdd', 'set_layout', true, 'u', layout or 0)
end
function prev_layout()
    return bus:call_method('ru.gentoo.KbddService', '/ru/gentoo/KbddService', 'ru.gentoo.kbdd', 'prev_layout', true)
end

widget:buttons(button({ }, 1, prev_layout))

setmetatable(_M, { __call = function (_, ...) return widget end })


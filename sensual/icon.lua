local setmetatable = setmetatable
local type = type
local capi = { widget = widget, image = image }
local layouts = require("awful.widget.layout")

module("sensual.icon")

local function set_value(w, icon_path)
    local img = icon_path
    if not img or img == "" then return end
    if type(img) == "string" then img = capi.image(img) end
    w.widget.image = img
end

local function set_background_color(w, bgcolor)
    w.widget.bg = bgcolor
end

function new(text, wargs)
    local w = {}
    local args = wargs or {}

    args.type = "imagebox"
    local widget = capi.widget(args)

    w.layout = args.layout or layouts.horizontal.rightleft
    w.widget = widget

    w.set_value = set_value
    w.set_background_color = set_background_color
    return w
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })


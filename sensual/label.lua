local setmetatable = setmetatable
local type = type
local unpack = unpack
local capi = { widget = widget }
local layouts = require("awful.widget.layout")
local theme = require("beautiful")
local helpers = require("sensual.helpers")

module("sensual.label")

local function attrs(w, text)
    return '<span color="' .. (w.color or theme.fg_normal or "#ffffff00") .. '" bgcolor="' .. (w.background_color or theme.bg_normal or "#000000ff") .. '">' .. text .. '</span>'
end

local function set_value(w, data)
    local text = ""
    if not data then data = "" end
    if type(w.format) == "function" then
        text = w.format(data)
    elseif type(data) == "table" then
        text = helpers.reformat(w.format, data)
    elseif type(w.format) == "string" then
        text = w.format:format(data)
    end
    w:set_text(text)
end

local function set_color(w, color)
    w.color = color
    w:set_text(w.text)
end

local function set_background_color(w, color)
    w.background_color = color
    w:set_text(w.text)
end

local function set_text(w, text)
    w.text = text
    w.widget.text = attrs(w, text)
end

function new(text, wargs)
    local w = {}
    local args = wargs or {}
    local txt = text or ""

    args.type = "textbox"
    local widget = capi.widget(args)
    widget.text = txt

    w.layout = args.layout or layouts.horizontal.rightleft
    w.widget = widget
    w.format = txt
    w.text = txt

    w.set_value = set_value
    w.set_color = set_color
    w.set_background_color = set_background_color
    w.set_text = set_text
    return w
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

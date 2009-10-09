----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries
----------------------------------------------------------

-- {{{ Grab environment
local pairs = pairs
local string = {
    sub = string.sub,
    gsub = string.gsub
}
local io = {
    open = io.open
}
-- }}}


-- Helpers: provides helper functions for vicious widgets
module("vicious.helpers")


-- {{{ Format a string with args
function format(format, args)
    for var, val in pairs(args) do
        format = string.gsub(format, "$" .. var, val)
    end

    return format
end
-- }}}

function scale(widget, args)
    local value = args[1]
    local max = args[2] or 100
    local min = args[3] or 0
    local mult = args[4] or 100

    return (value - min) * mult / max
end

function readfile(filename, format)
    local f = io.open(filename)
    if f then
        local line = f:read(format or "*a")
        f:close()
        return line
    end
end

--{{{ Escape a string
function escape(text)
    local xml_entities = {
        ["\""] = "&quot;",
        ["&"]  = "&amp;",
        ["'"]  = "&apos;",
        ["<"]  = "&lt;",
        [">"]  = "&gt;"
    }

    return text and text:gsub("[\"&'<>]", xml_entities)
end
-- }}}

--{{{ Truncate a string
function truncate(text, maxlen)
    local txtlen = text:len()

    if txtlen > maxlen then
        text = text:sub(1, maxlen - 3) .. "..."
    end

    return text
end
-- }}}

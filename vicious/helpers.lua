----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries
----------------------------------------------------------

-- {{{ Grab environment
local type = type
local ipairs = ipairs
local unpack = unpack
local tonumber = tonumber
local io = {
    open = io.open
}
local table = {
    insert = table.insert
}
-- }}}


-- Helpers: provides helper functions for vicious widgets
module("vicious.helpers")

--{{{ Read data from file
function readfile(filename, format)
    local f = io.open(filename)
    if f then
        local line = f:read(format or "*a")
        f:close()
        return line
    end
end

function readtfile(filename, format)
    local f = io.open(filename)
    local result = {}
    local format = format or "%d+"
    if f then
        format = "^(%w[%w%d]+):%s("..format..")"
        for line in f:lines() do
            local key, value = line:match(format)
            if key then result[key] = value end
        end
        f:close()
    end
    return result
end
-- }}}

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

function slice(tbl, start, stop)
    local result = {}
    if type(start) == "table" then
        for i, k in ipairs(start) do
            result[i] = tbl[k]
        end
    else
        if start == nil and stop == nil then
            return tbl
        else
            local start = start or 1
            local stop = stop or #tbl
            for i = start, stop do
                table.insert(result, tbl[i])
            end
        end
    end
    return result
end

function reformat(frm, pars)
    local args = {}
    for p in frm:gmatch("%%%(([%d%w]+)%)") do
        table.insert(args, pars[tonumber(p) or p])
        frm = frm:gsub("%%%("..p.."%)", "%%")
    end
    return frm:format(unpack(#args > 0 and args or pars))
end


----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries
----------------------------------------------------------

-- {{{ Grab environment
local type = type
local ipairs = ipairs
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

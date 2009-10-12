----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries
----------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { open = io.open }
local setmetatable = setmetatable
local math = { floor = math.floor }
local helpers = require("vicious.helpers")
-- }}}


-- Uptime: provides system uptime information
module("vicious.uptime")

function meta() return {} end

-- {{{ Uptime widget type
local function worker(format)
    -- Get /proc/uptime
    local line = helpers.readfile("/proc/uptime", "*line")
    local total_uptime   = math.floor(tonumber(line:match("[%d%.]+")))
    -- use vicious.formatters.hms() to get days/hours/mins/secs
    return { total_uptime }
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })

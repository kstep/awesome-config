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
local helpers = require("sensual.helpers")
-- }}}


-- Uptime: provides system uptime information
module("sensual.uptime")

-- {{{ Uptime widget type
function worker(self)
    -- Get /proc/uptime
    local line = helpers.readfile("/proc/uptime", "*line")
    local total_uptime   = math.floor(tonumber(line:match("[%d%.]+")))
    -- use sensual.formatters.hms() to get days/hours/mins/secs
    return { total_uptime }
end
-- }}}

local sensor
local function new()
    if not sensor then
        sensor = { meta = {} }
        setmetatable(sensor, { __call = worker })
    end
    return sensor
end


setmetatable(_M, { __call = function(_, ...) return new(...) end })

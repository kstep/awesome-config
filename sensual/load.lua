----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local io = { open = io.open }
local setmetatable = setmetatable
-- }}}


-- Load: provides system load averages for the past 1, 5, and 15 minutes
module("sensual.load")


-- {{{ Load widget type
local function worker(widget)
    -- Get load averages
    local f = io.open('/proc/loadavg')
    local line = f:read("*line")
    f:close()

    local avg1, avg5, avg15, running_procs, total_procs, recent_pid = 
        line:match("([%d]*%.[%d]*)%s([%d]*%.[%d]*)%s([%d]*%.[%d]*)%s([%d]*)/([%d]*)%s([%d]*)")

    return {avg1, avg5, avg15, running_procs, total_procs, recent_pid}
end
-- }}}

local sensor
local function new()
    if not sensor then
        sensor = {}
        sensor.meta = {min = 0, max = 3}
        setmetatable(sensor, { __call = worker })
    end
    return sensor
end


setmetatable(_M, { __call = function(_, ...) return new(...) end })

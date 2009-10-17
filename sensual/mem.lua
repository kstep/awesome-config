----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries
----------------------------------------------------------

-- {{{ Grab environment
local tonumber = tonumber
local io = { open = io.open }
local setmetatable = setmetatable
local math = { floor = math.floor, max = math.max }
local helpers = require('sensual.helpers')
-- }}}


-- Mem: provides RAM and Swap usage statistics
module("sensual.mem")

-- {{{ Memory widget type
function worker(self)
    -- Get meminfo
    local data = helpers.readtfile("/proc/meminfo", "%d+")
    local mem_free = tonumber(data['MemFree']) + tonumber(data['Cached']) + tonumber(data['Buffers'])
    local swap_free = tonumber(data['SwapFree'])

    local mem_used = tonumber(data['MemTotal'] - mem_free)
    local swap_used = tonumber(data['SwapTotal'] - swap_free)

    return { mem_used, swap_used, mem_free, swap_free }
end
-- }}}

local sensor
function new(warg)
    if not sensor then
        sensor = {}
        local data = helpers.readtfile("/proc/meminfo", "%d+")
        --meta.max = math.max(data['MemTotal'], data['SwapTotal'])
        sensor.meta = { max = data['MemTotal'], init = 2 }
        sensor.args = warg
        setmetatable(sensor, { __call = worker })
    end
    return sensor
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

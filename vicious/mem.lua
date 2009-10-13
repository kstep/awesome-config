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
local helpers = require('vicious.helpers')
local max = math.max
-- }}}


-- Mem: provides RAM and Swap usage statistics
module("vicious.mem")

function meta(warg)
    local data = readtfile("/proc/meminfo", "%d+")
    local meta = {}
    meta.max = max(data['MemTotal'], data['SwapTotal'])
    meta.init = 2
    return meta
end


-- {{{ Memory widget type
local function worker(format)
    -- Get meminfo
    local data = readtfile("/proc/meminfo", "%d+")
    local mem_free = tonumber(data['MemFree']) + tonumber(data['Cached']) + tonumber(data['Buffers'])
    local swap_free = tonumber(data['SwapFree'])

    local mem_used = tonumber(data['MemTotal'] - mem_free)
    local swap_used = tonumber(data['SwapTotal'] - swap_free)

    return { mem_used, swap_used }
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })

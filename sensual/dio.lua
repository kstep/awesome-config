----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local type = type
local ipairs = ipairs
local io = { open = io.open }
local setmetatable = setmetatable
local math = { floor = math.floor }
local table = { insert = table.insert }
local helpers = require("sensual.helpers")
-- }}}

-- Disk I/O: provides I/O statistics for requested storage devices
module("sensual.dio")

function worker(self)
    local line = helpers.readfile("/sys/class/block/" .. self.args .. "/stat", "*l")
    local data = { line:match("(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)") }
    local stat = {}
    stat.reads       = data[1]
    stat.tot_reads   = data[2]
    stat.sec_read    = data[3]
    stat.bytes_read  = data[3]*512
    stat.ms_read     = data[4]
    stat.writes      = data[5]
    stat.tot_writes  = data[6]
    stat.sec_write   = data[7]
    stat.bytes_write = data[7]*512
    stat.ms_write    = data[8]
    stat.ios         = data[9]
    stat.ms_ios      = data[10]
    stat.tot_ms_ios  = data[11]
    return stat
end

local sensors = {}
local function new(dev)
    if not sensors[dev] then
        sensors[dev] = { args = dev, meta = {} }
        setmetatable(sensors[dev], { __call = worker })
    end
    return sensors[dev]
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

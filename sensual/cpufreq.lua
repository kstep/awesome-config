----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
----------------------------------------------------------

-- {{{ Grab environment
local io = { open = io.open }
local setmetatable = setmetatable
local string = {
    find = string.find,
    match = string.match
}
local helpers = require("sensual.helpers")
-- }}}


-- Cpufreq: provides freq, voltage and governor info for a requested CPU
module("sensual.cpufreq")

local basedir = "/sys/devices/system/cpu/"

-- {{{ CPU frequency widget type
function worker(self)
    --local governor_state = {
    --    ["ondemand"] = "↯",
    --    ["powersave"] = "⌁",
    --    ["userspace"] = "°",
    --    ["performance"] = "⚡",
    --    ["conservative"] = "↯"
    --}

    -- Get the current frequency
    local freq = helpers.readfile(basedir .. self.args .. "/cpufreq/scaling_cur_freq", "*n")
    return { freq }
end
-- }}}

local function new(cpuid)
    local sensor = {}
    local max_freq = helpers.readfile(basedir .. cpuid .. "/cpufreq/scaling_max_freq", "*n")
    local min_freq = helpers.readfile(basedir .. cpuid .. "/cpufreq/scaling_min_freq", "*n")
    sensor.meta = { min = min_freq, max = max_freq, suffixes = {"KHz", "MHz", "GHz"}, scale = 1000 }
    sensor.args = cpuid
    setmetatable(sensor, { __call = worker })
    return sensor
end


setmetatable(_M, { __call = function(_, ...) return new(...) end })

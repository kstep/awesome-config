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
local helpers = require("vicious.helpers")
-- }}}


-- Cpufreq: provides freq, voltage and governor info for a requested CPU
module("vicious.cpufreq")

local basedir = "/sys/devices/system/cpu/"
local cpu_data = {}

-- {{{ CPU frequency widget type
local function worker(format, cpuid)
    --local governor_state = {
    --    ["ondemand"] = "↯",
    --    ["powersave"] = "⌁",
    --    ["userspace"] = "°",
    --    ["performance"] = "⚡",
    --    ["conservative"] = "↯"
    --}

    -- Get the current frequency
    local freq = helpers.readfile(basedir .. cpuid .. "/cpufreq/scaling_cur_freq", "*n")

    if cpu_data[cpuid] == nil then
        local max_freq = helpers.readfile(basedir .. cpuid .. "/cpufreq/scaling_max_freq", "*n")
        local min_freq = helpers.readfile(basedir .. cpuid .. "/cpufreq/scaling_min_freq", "*n")
        cpu_data[cpuid] = { max_freq, min_freq }
    end

    return {freq, cpu_data[cpuid][1], cpu_data[cpuid][2], format = " %3.1f %s ", suffixes = {"KHz", "MHz", "GHz"}, scale = 1000}
end
-- }}}

setmetatable(_M, { __call = function(_, ...) return worker(...) end })

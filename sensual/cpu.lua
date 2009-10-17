----------------------------------------------------------
-- Licensed under the GNU General Public License version 2
--  * Copyright (C) 2009 Adrian C. <anrxc_sysphere_org>
--  * Derived from Wicked, copyright of Lucas de Vries
----------------------------------------------------------

-- {{{ Grab environment
local ipairs = ipairs
local io = { open = io.open }
local setmetatable = setmetatable
local math = { floor = math.floor }
local table = { insert = table.insert }
-- }}}


-- Cpu: provides CPU usage for all available CPUs/cores
module("sensual.cpu")


-- Initialise function tables
local cpu_usage  = {}
local cpu_total  = {}
local cpu_active = {}
local cpu_iowait = {}

-- {{{ CPU widget type
function worker(self)
    -- Get /proc/stat
    local f = io.open("/proc/stat")
    local cpu_lines = {}

    for line in f:lines() do
        if line:find("^cpu") then
            if #cpu_lines < 1 then cpuid = 1
            else cpuid = #cpu_lines + 1 end

            cpu_lines[cpuid] = {}
            for match in line:gmatch("[%s]+([%d]+)") do
                  table.insert(cpu_lines[cpuid], match)
            end
        else
            break
        end
    end
    f:close()

    local cpu_num = #cpu_lines

    -- Ensure tables are initialized correctly
    while #cpu_total < 2*cpu_num do
        table.insert(cpu_total, 0)
    end
    while #cpu_active < cpu_num do
        table.insert(cpu_active, 0)
    end
    while #cpu_usage < cpu_num do
        table.insert(cpu_usage, 0)
    end
    while #cpu_iowait < cpu_num do
        table.insert(cpu_iowait, 0)
    end

    local total_new
    local active_new
    local iowait_new

    local diff_total
    local diff_active
    local diff_iowait

    for i, v in ipairs(cpu_lines) do
        -- Calculate totals
        total_new = 0
        for j = 1, #v do
            total_new = total_new + v[j]
        end
        active_new = v[1] + v[2] + v[3]
        iowait_new = v[5]

        -- Calculate percentage
        diff_total  = total_new - cpu_total[i]
        diff_active = active_new - cpu_active[i]
        diff_iowait = iowait_new - cpu_iowait[i]

        cpu_usage[i] = math.floor(diff_active * 100 / diff_total)
        cpu_usage[i+cpu_num] = math.floor(diff_iowait * 100 / diff_total)

        -- Store totals
        cpu_total[i]  = total_new
        cpu_active[i] = active_new
        cpu_iowait[i] = iowait_new
    end

    return cpu_usage
end
-- }}}

local sensor
local function new(args)
    if not sensor then
        sensor = {}
        sensor.meta = {}
        sensor.args = args
        setmetatable(sensor, { __call = worker })
    end
    return sensor
end

setmetatable(_M, { __call = function(_, ...) return new(...) end })

local utils = require("lifty.utils")
local sensor_base = require("lifty.sensors.base")

local io = { open = io.open }
local table = { remove = table.remove }

module("lifty.sensors.cpu")

local base_syspath = "/sys/devices/system/cpu"

local function humanize_freq(self, value)
	return utils.humanize(value or self:get_value(), 1000, { 'Hz', 'MHz', 'GHz' }, 1)
end

function frequency(num)
	local cpufreq = sensor_base()

	cpufreq.name = "cpu" .. num
	cpufreq.path = base_syspath .. "/" .. cpufreq.name .. "/cpufreq"
	cpufreq.fname = "scaling_cur_freq"
	cpufreq.max_value = utils.fread_num(cpufreq.path .. "/scaling_max_freq")
	cpufreq.min_value = utils.fread_num(cpufreq.path .. "/scaling_min_freq")

	cpufreq.humanize = humanize_freq

	return cpufreq
end

local function get_load_value(self)
    local timesh = io.open("/proc/stat")
	local times = { "" }
	while times[1] ~= self.name do
		times = { timesh:read("*l"):match("(cpu%d*) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)") }
	end
	table.remove(times, 1)
	timesh:close()

	local sum = utils.table_sum(times)
	local cpuload = 0
	if self.cache then
		if self.cache[1] < sum then
			cpuload = 100 - (times[4] - self.cache[2]) * 100 / (sum - self.cache[1])
		end
	end
	self.cache = { sum, times[4] }
	return cpuload
end

function loadstat(num)
	local cpuload = sensor_base()

	cpuload.name = num and "cpu" .. num or "cpu"
	cpuload.cache = { 0, 0 }

	cpuload.get_value = get_load_value

	return cpuload
end

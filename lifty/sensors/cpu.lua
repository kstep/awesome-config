local utils = require("lifty.utils")
local io = {
	open = io.open,
}
local table = {
	remove = table.remove
}
local setmetatable = setmetatable

module("lifty.sensors.cpu")

local base_syspath = "/sys/devices/system/cpu"

local function get_freq_value(self)
	local freq = utils.fread_num(self.path .. "/scaling_cur_freq")
	return freq
end

local function get_freq_data(self)
	local data = {}
	data["max_value"] = self.max_value
	data["min_value"] = self.min_value
	data["value"] = self:get_value()
	return data
end

function frequency(num)
	local cpufreq = {}

	cpufreq.name = "cpu" .. num
	cpufreq.path = base_syspath .. "/" .. cpufreq.name .. "/cpufreq"
	cpufreq.max_value = utils.fread_num(cpufreq.path .. "/scaling_max_freq")
	cpufreq.min_value = utils.fread_num(cpufreq.path .. "/scaling_min_freq")

	cpufreq.get_value = get_freq_value
	cpufreq.get_data = get_freq_data
	setmetatable(cpufreq, { __call = get_freq_data })

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

local function get_load_data(self)
	local data = {}
	data["value"] = self:aload()
	return data
end

function loadstat(num)
	local cpuload = {}

	cpuload.name = num and "cpu" .. num or "cpu"
	cpuload.cache = { 0, 0 }

	cpuload.get_value = get_load_value
	cpuload.get_data = get_load_data
	setmetatable(cpuload, { __call = get_freq_data })

	return cpuload
end

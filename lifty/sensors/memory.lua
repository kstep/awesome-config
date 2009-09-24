local tonumber = tonumber
local utils = require("lifty.utils")
local base_sensor = require("lifty.sensors.base")

module("lifty.sensors.memory")

local base_syspath = "/proc/meminfo"
local total_memory
local total_swap
local cache = {}

local function read_cache(name)
	local value = cache[name]
	if not value then
		cache = utils.fread_table(base_syspath)
		value = cache[name]
		cache[name] = nil
	end
	return tonumber(value)
end

local function get_value(self)
	return read_cache(self.name)
end

local function get_free_memory(self)
	return read_cache("MemFree") + read_cache("Cached") + read_cache("Buffers")
end

local function meminfo(name)
	local meminfo = base_sensor()
	meminfo.path = base_syspath
	meminfo.name = name

	if not total_memory or not total_swap then
		local data = utils.fread_table(meminfo.path)
		total_memory = tonumber(data["MemTotal"])
		total_swap = tonumber(data["SwapTotal"])
	end

	meminfo.max_value = total_memory
	meminfo.get_value = get_value
	meminfo.humanize = function (self, value)
		return utils.humanize(value or self:get_value(), 1024, { "b", "K", "M", "G", "T" }, 2)
	end

	return meminfo
end

function memfree()
	local sensor = meminfo("MemFree")
	return sensor
end

function unwired()
	local sensor = meminfo("")
	sensor.get_value = get_free_memory
	return sensor
end

function swapfree()
	local sensor = meminfo("SwapFree")
	sensor.max_value = total_swap
	return sensor
end

function buffers()
	local sensor = meminfo("Buffers")
	return sensor
end

function cached()
	local sensor = meminfo("Cached")
	return sensor
end

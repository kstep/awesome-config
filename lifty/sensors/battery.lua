local utils = require("lifty.utils")
local setmetatable = setmetatable

module("lifty.sensors.battery")

local base_syspath = "/sys/class/power_supply"
local battery_maxcharges = {}

local function charge(self)
	local cur_charge = utils.fread_num(self.path .. "/charge_now")		
	return cur_charge > 0 and cur_charge * 100 / self.max_value
end

local function status(self)
	local status = utils.fread_num(self.path .. "/status", "*l")
	return status
end

local function get_info(self)
	local data = {}
	data["value"] = self:get_value()
	data["state"] = self:get_state()
	return data
end

function new(self, num)
	local battery = {}
	battery.name = "BAT" .. num
	battery.path = base_syspath .. "/" .. battery.name
	battery.max_value = utils.fread_num(battery.path .. "/charge_full")

	battery.get_value = charge
	battery.get_state = status
	battery.get_info = get_info

	setmetatable(battery, { __call = get_info })
	return battery
end

setmetatable(_M, { __call = new })

local utils = require("lifty.utils")
local setmetatable = setmetatable

module("lifty.sensors.battery")

local base_syspath = "/sys/class/power_supply"
local battery_maxcharges = {}

local function charge(self)
	local cur_charge = utils.fread_num(self.path .. "/charge_now")		
	return cur_charge > 0 and cur_charge * 100 / self.max_charge
end

local function status(self)
	local status = utils.fread_num(self.path .. "/status", "*l")
	return status
end

local function get_data(self)
	local data = {}
	data["value"] = self:charge()
	data["state"] = self:status()
	return data
end

function new(self, num)
	local battery = {}
	battery.name = "BAT" .. num
	battery.path = base_syspath .. "/" .. battery.name
	battery.max_charge = utils.fread_num(battery.path .. "/charge_full")

	battery.charge = charge
	battery.status = status
	battery.get_data = get_data

	setmetatable(battery, { __call = get_data })
	return battery
end

setmetatable(_M, { __call = new })

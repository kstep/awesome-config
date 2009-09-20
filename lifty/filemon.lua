local utils = require("lifty.utils")

module("lifty.filemon")

function new_stat_bar(base_sysdir, params)
	local min_value = params['min_value'] or 0
	local max_value = params['max_value'] or 100
	
	if (type(min_value) == "string") then min_value = utils.fread_num(base_sysdir.."/"..min_value) end
	if (type(max_value) == "string") then max_value = utils.fread_num(base_sysdir.."/"..max_value) end
	params["min_value"] = min_value
	params["max_value"] = max_value

	return params
end

local monitors = {}

function register_sysmon(base_sysdir)
	local monitor = function ()
		local data = utils.fread_num(base_sysdir)
	end
	table.insert(monitors, monitor)
end

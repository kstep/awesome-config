local util = require("awful.util")
local io = { popen = io.popen }
local setmetatable = setmetatable

module("sensual.cmus")

function cmus_exec(cmd)
    util.spawn('cmus-remote --raw ' .. cmd, false)
end

function cmus_cmd(cmd)
    return function ()
        return util.spawn("cmus-remote --" .. cmd, false)
    end
end

function cmus_query()
    local result = { tag = {}, set = {} }
    local data = io.popen("cmus-remote --query")
    if data then
        local line, name, subname, value
        for line in data:lines() do
            name, value = line:match('^([a-z_]+) (.+)$')
            if name then
                if name == 'tag' or name == 'set' then
                    subname, value = value:match('^([a-z_]+) (.+)$')
                    if name == 'set' then
                        if value == 'disabled' then
                            value = nil
                        elseif value == 'true' then
                            value = true
                        elseif value == 'false' then
                            value = false
                        end
                    end
                    result[name][subname] = value
                else
                    result[name] = value
                end
            end
        end
        data:close()
    end
    return result
end

local sensor
local function new()
    if not sensor then
        sensor = { meta = {} }
        setmetatable(sensor, { __call = cmus_query })
    end
    return sensor
end

setmetatable(_M, { __call = function (_, ...) end })


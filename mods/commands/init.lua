local S = minetest.get_translator("commands")

local function split_args(args_string)
	local args = {}
	for arg in args_string:gmatch("%S+") do
		table.insert(args, arg)
	end
	return args
end

minetest.register_chatcommand("clearitems", {
	description = S("Removes all dropped items in the world"),
	func = function(name, param)
		local count = 0
		for _, obj in pairs(minetest.object_refs) do
			local entity = obj:get_luaentity()
			if entity and entity.name == "__builtin:item" then
				count = count + 1
				obj:remove()
			end
		end
		return true, S("Removed items") .. ": " .. count
	end
})

minetest.register_chatcommand("time", {
	description = "<get> | <set> <day|night|numeric>: " .. S("Time operation command, can get or set time of day"),
	func = function(name, param)
		local args = split_args(param)
		if args[1] == "get" then
			local time = minetest.get_timeofday()
			time = math.floor((time - 0.25) * 24000 + 24000) % 24000
			return true, S("Current time of day") .. ": " .. time
		end
		if args[1] == "set" and args[2] then
			if args[2] == "day" then
				minetest.set_timeofday(0.22)
				return true, S("Time set to day")
			end
			if args[2] == "night" then
				minetest.set_timeofday(0.8)
				return true, S("Time set to night")
			end
			local time = tonumber(args[2])
			if not time then
				return false
			end
			time = (time / 24000 + 0.25) % 1.0
			minetest.set_timeofday(time)
			return true, S("Time of day was set to") .. ": " .. args[2]
		end
		return false
	end
})

-- minetest.emerge_area(pos1, pos2, [callback], [param])

local function update_area(player, p1, p2)
	minetest.emerge_area(p1, p2)
	minetest.load_area(p1, p2)

	local x1 = math.floor(p1.x / 16)
	local y1 = math.floor(p1.y / 16)
	local z1 = math.floor(p1.z / 16)
	local x2 = math.ceil(p2.x / 16)
	local y2 = math.ceil(p2.y / 16)
	local z2 = math.ceil(p2.z / 16)

	for x = x1, x2 do
		for z = z1, z2 do
			for y = y1, y2 do
		
			end
		end
	end
end

minetest.register_chatcommand("loadarea", {
	description = "here <radius> | x1, y1, z1, x2, y2, z2: " .. S("Forces area to be loaded and generated"),
	func = function(name, param)
		local args = split_args(param)
		local player = minetest.get_player_by_name(name)

		if args[1] == "here" then
			local radius = tonumber(args[2])
			
			if not radius then
				return false
			end

			local pos = player:get_pos()
			local p1 = vector.new(math.floor(pos.x - radius), math.floor(pos.y - radius), math.floor(pos.z - radius))
			local p2 = vector.new(math.ceil(pos.x + radius), math.ceil(pos.y + radius), math.ceil(pos.z + radius))
			update_area(player, p1, p2)

			return true, S("Area was loaded")
		end

		if #args ~= 7 then
			return false
		end

		local x1 = tonumber(args[2])
		local y1 = tonumber(args[3])
		local z1 = tonumber(args[4])
		local x2 = tonumber(args[5])
		local y2 = tonumber(args[6])
		local z2 = tonumber(args[7])

		if not x1 or not x2 or not y1 or not y2 or not z1 or not z2 then
			return false
		end

		local p1 = vector.new(x1, y1, z1)
		local p2 = vector.new(x2, y2, z2)

		update_area(player, p1, p2)

		return true, S("Area was loaded")
	end
})
MINING_LEVELS = {
	TOOLS = {
		PICKAXE = "required_tool_pickaxe",
		AXE = "required_tool_axe",
		SHOVEL = "required_tool_showel",
		SHEARS = "required_tool_shears"
	},
	LEVELS = {
		HAND = 1,
		WOOD = 2,
		STONE = 3,
		IRON = 4,
		GOLD = 4,
		DIAMOND = 5
	},
	make_tool_capabilities = function(tool_type, tool_level, uses, mining_speed)
		local times = {}
		local max_level = 1

		if not uses then
			uses = 0
		end
		if not mining_speed then
			mining_speed = 1.0
		end

		for _, level in pairs(MINING_LEVELS.LEVELS) do
			local time = level / tool_level
			if time > 1 then
				time = time * 3
			end
			if time < 1 then
				time = time * 0.75
			end
			times[level] = time
			if level > max_level then
				max_level = level
			end
		end

		local groupcaps = {}

		if tool_type then
			groupcaps[tool_type] = {
				times = times,
				uses = uses,
				max_drop_level = tool_level
			}
		end

		times = {}

		for _, level in pairs(MINING_LEVELS.LEVELS) do
			local time = level
			if time > 1 then
				time = time * 3
			end
			if time < 1 then
				time = time * 0.75
			end
			times[level] = time / mining_speed
		end

		for _, tool in pairs(MINING_LEVELS.TOOLS) do
			if not groupcaps[tool] then
				groupcaps[tool] = {
					times = times,
					uses = uses,
					max_drop_level = 1
				}
			end
		end

		groupcaps["breakable_by_hand"] = {
			times = times,
			uses = uses,
			max_drop_level = 255
		}

		return {
			groupcaps = groupcaps
		}
	end,
	can_break = function(node_name, tool_name)
		local node = minetest.registered_nodes[node_name]
		if not node then
			return false
		end

		local tool = minetest.registered_items[tool_name]
		if not tool then
			return false
		end
	end
}

local EMPTY = {}
local get_node_drops = minetest.get_node_drops

minetest.get_node_drops = function(node, tool_name)
	local tool_def = minetest.registered_items[tool_name] or EMPTY
	local tool_cap = tool_def.tool_capabilities or EMPTY
	local group_cap = tool_cap.groupcaps or EMPTY

	local node_name

	if type(node) == "table" then
		node_name = node.name
	else
		node_name = node
	end

	local node_def = minetest.registered_nodes[node_name] or EMPTY
	local node_groups = node_def.groups or EMPTY

	if node_groups["breakable_by_hand"] then
		return get_node_drops(node_name, tool_name)
	end

	for group, level in pairs(node_groups) do
		local cap = group_cap[group]
		if cap then
			local max_drop_level = cap.max_drop_level or 0
			if level <= max_drop_level then
				return get_node_drops(node_name, tool_name)
			end
		end
	end

	return EMPTY
end
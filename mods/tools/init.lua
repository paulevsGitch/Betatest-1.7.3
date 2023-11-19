local S = minetest.get_translator("stones")
local EMPTY = {}

local function use_tool(itemstack, user, node, digparams)
	local item = minetest.registered_items[itemstack:get_name()]
	local max_usages = item._max_usages or 0

	itemstack:add_wear_by_uses(max_usages)

	if itemstack:is_empty() then
		local base_texture = (item.wield_image or item.inventory_image) .. "^[sheet:4x4:"

		local def = {
			pos = user:get_pos(),
			velocity = vector.zero(),
			acceleration = vector.new(0, -6, 0),
			expirationtime = 1,
			size = 2,
			collisiondetection = false,
			collision_removal = false,
			object_collision = false,
			vertical = false,
			texture = base_texture
		}

		local pos = def.pos
		local dir = user:get_look_dir()
		local side = vector.normalize(vector.cross(dir, vector.new(0, 1, 0)))

		pos.x = pos.x + dir.x * 0.5 - side.x * 0.25
		pos.y = pos.y + dir.y * 0.5 - side.y * 0.25 + 1.5
		pos.z = pos.z + dir.z * 0.5 - side.z * 0.25

		for _ = 1, 30 do
			local velocity = def.velocity
			velocity.x = math.random() * 3 - 1.5
			velocity.y = math.random() * 3 - 1.5
			velocity.z = math.random() * 3 - 1.5
			def.texture = base_texture .. math.random(1, 4) .. "," .. math.random(1, 4)
			minetest.add_particle(def)
		end

		minetest.sound_play({name = "tools_break"}, {to_player = user:get_player_name()}, true)
	end

	return itemstack
end

local function register_toolset(material_name, tool_level, uses, mining_speed)
	local prefix = material_name:gsub("^%l", string.upper)

	minetest.register_tool("tools:" .. material_name .. "_pickaxe", {
		description = S(prefix .. " Pickaxe"),
		groups = {tool = 1, pickaxe = 1},
		inventory_image = "tools_" .. material_name .. "_pickaxe.png",
		wield_image = "tools_" .. material_name .. "_pickaxe.png",
		stack_max = 1,
		range = 5.0,
		tool_capabilities = MINING_LEVELS.make_tool_capabilities(MINING_LEVELS.tools.PICKAXE, tool_level, uses, mining_speed),
		after_use = use_tool,
		_max_usages = uses
	})

	minetest.register_tool("tools:" .. material_name .. "_axe", {
		description = S(prefix .. " Axe"),
		groups = {tool = 1, pickaxe = 1},
		inventory_image = "tools_" .. material_name .. "_axe.png",
		wield_image = "tools_" .. material_name .. "_axe.png",
		stack_max = 1,
		range = 5.0,
		tool_capabilities = MINING_LEVELS.make_tool_capabilities(MINING_LEVELS.tools.AXE, tool_level, uses, mining_speed),
		after_use = use_tool,
		_max_usages = uses
	})

	minetest.register_tool("tools:" .. material_name .. "_shovel", {
		description = S(prefix .. " Shovel"),
		groups = {tool = 1, pickaxe = 1},
		inventory_image = "tools_" .. material_name .. "_shovel.png",
		wield_image = "tools_" .. material_name .. "_shovel.png",
		stack_max = 1,
		range = 5.0,
		tool_capabilities = MINING_LEVELS.make_tool_capabilities(MINING_LEVELS.tools.AXE, tool_level, uses, mining_speed),
		after_use = use_tool,
		_max_usages = uses
	})

	minetest.register_tool("tools:" .. material_name .. "_hoe", {
		description = S(prefix .. " Hoe"),
		groups = {tool = 1, pickaxe = 1},
		inventory_image = "tools_" .. material_name .. "_hoe.png",
		wield_image = "tools_" .. material_name .. "_hoe.png",
		stack_max = 1,
		range = 5.0,
		tool_capabilities = MINING_LEVELS.make_tool_capabilities(MINING_LEVELS.tools.AXE, tool_level, uses, mining_speed),
		after_use = use_tool,
		_max_usages = uses
	})
end

register_toolset("wooden", MINING_LEVELS.levels.WOOD, 60)
register_toolset("stone", MINING_LEVELS.levels.STONE, 130)
register_toolset("iron", MINING_LEVELS.levels.IRON, 250)
register_toolset("golden", MINING_LEVELS.levels.GOLD, 30, 2.0)
register_toolset("diamond", MINING_LEVELS.levels.DIAMOND, 1560)
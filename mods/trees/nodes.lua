local S = minetest.get_translator("stones")

local function register_tree(name)
	local reg_name = name:lower():gsub(" ", "_")
	local log_name = "trees:" .. reg_name .. "_log"
	local leaves_name = "trees:" .. reg_name .. "_leaves"
	local tex_side = "trees_" .. reg_name .. "_log_side.png"
	local tex_top = "trees_" .. reg_name .. "_log_top.png"
	local tex_leaves = "trees_" .. reg_name .. "_leaves.png"

	minetest.register_node(log_name, {
		description = S(name .. " Log"),
		tiles = {tex_top, tex_top, tex_side},
		groups = {
			[MINING_LEVELS.TOOLS.AXE] = MINING_LEVELS.LEVELS.WOOD,
			breakable_by_hand = 1,
			log = 1
		}
	})
	
	minetest.register_node(leaves_name, {
		description = S(name .. " Leaves"),
		tiles = {tex_leaves},
		drawtype = "allfaces",
		paramtype = "light",
		waving = 2,
		groups = {
			[MINING_LEVELS.TOOLS.SHEARS] = 1,
			breakable_by_hand = 1,
			leaves = 1
		}
	})
end

register_tree("Oak")
register_tree("Spruce")
register_tree("Birch")

minetest.register_node("trees:oak_planks", {
	description = S("Oak Log"),
	tiles = {"trees_oak_planks.png"},
	groups = {
		[MINING_LEVELS.TOOLS.AXE] = MINING_LEVELS.LEVELS.WOOD,
		breakable_by_hand = 1,
		planks = 1
	}
})
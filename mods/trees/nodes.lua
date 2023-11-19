local S = minetest.get_translator("stones")

minetest.register_node("trees:oak_log", {
	description = S("Oak Log"),
	tiles = {"trees_oak_log_top.png", "trees_oak_log_top.png", "trees_oak_log_side.png"},
	groups = {
		[MINING_LEVELS.tools.AXE] = MINING_LEVELS.levels.WOOD,
		breakable_by_hand = 1,
		log = 1
	}
})

minetest.register_node("trees:oak_leaves", {
	description = S("Oak Leaves"),
	tiles = {"trees_oak_leaves.png"},
	drawtype = "allfaces",
	paramtype = "light",
	waving = 2,
	groups = {
		[MINING_LEVELS.tools.SHEARS] = 1,
		breakable_by_hand = 1,
		leaves = 1
	}
})

minetest.register_node("trees:oak_planks", {
	description = S("Oak Log"),
	tiles = {"trees_oak_planks.png"},
	groups = {
		[MINING_LEVELS.tools.AXE] = MINING_LEVELS.levels.WOOD,
		breakable_by_hand = 1,
		planks = 1
	}
})
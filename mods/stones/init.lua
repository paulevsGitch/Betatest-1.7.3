local S = minetest.get_translator("stones")

minetest.register_node("stones:stone", {
	description = S("Stone"),
	tiles = {"stones_stone.png"},
	groups = {
		[MINING_LEVELS.tools.PICKAXE] = MINING_LEVELS.levels.WOOD,
		stone = 1
	},
	drop = "stones:cobblestone"
})

minetest.register_node("stones:cobblestone", {
	description = S("Cobblestone"),
	tiles = {"stones_cobblestone.png"},
	groups = {
		[MINING_LEVELS.tools.PICKAXE] = MINING_LEVELS.levels.WOOD,
		stone = 1
	}
})

minetest.register_node("stones:bedrock", {
	description = S("Bedrock"),
	tiles = {"stones_bedrock.png"},
	groups = {stone = 1}
})
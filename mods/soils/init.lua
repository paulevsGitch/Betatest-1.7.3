local S = minetest.get_translator("soils")

minetest.register_node("soils:dirt", {
	description = S("Dirt"),
	tiles = {"soils_dirt.png"},
	groups = {
		breakable_by_hand = 1,
		soil = 1
	}
})

minetest.register_node("soils:dirt_with_grass", {
	description = S("Grass Block"),
	tiles = {"soils_grass_top.png^[multiply:#89be5c", "soils_dirt.png", "soils_dirt_with_grass_side.png^(soils_grass_side.png^[multiply:#89be5c)"},
	groups = {
		breakable_by_hand = 1,
		soil = 1
	}
})

minetest.register_node("soils:sand", {
	description = S("Sand"),
	tiles = {"soils_sand.png"},
	groups = {
		breakable_by_hand = 1,
		falling_node = 1,
		soil = 1
	}
})

minetest.register_node("soils:gravel", {
	description = S("Gravel"),
	tiles = {"soils_gravel.png"},
	groups = {
		breakable_by_hand = 1,
		falling_node = 1,
		soil = 1
	}
})
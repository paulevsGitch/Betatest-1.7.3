local S = minetest.get_translator("soils")
local hm_noise

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
	paramtype2 = "color",
	palette = "soils_grass_palette.png",
	tiles = {
		{name = "soils_grass_top.png"},
		{name = "soils_dirt.png", color = "white"},
		{name = "soils_dirt_with_grass_side.png", color = "white"}
	},
	overlay_tiles = {"", "", {name = "soils_grass_side.png"}},
	color = "#89be5c",
	groups = {
		breakable_by_hand = 1,
		soil = 1
	},
	on_place = function (itemstack, placer, pointed_thing)
		if not hm_noise then
			hm_noise = environment.make_noises()
		end
		local t = hm_noise.get_temperature(pointed_thing.under)
		local h = hm_noise.get_humidity(pointed_thing.under)
		local param2 = h * 16 + t
		return minetest.item_place_node(itemstack, placer, pointed_thing, param2)
	end
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
local S = minetest.get_translator()

local texture_source = {
	name = "fluids_water.png",
	backface_culling = false,
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 8.0,
	}
}

local texture_flowing = {
	name = "fluids_water.png",
	backface_culling = false,
	animation = {
		type = "vertical_frames",
		aspect_w = 16,
		aspect_h = 16,
		length = 4.0,
	}
}

minetest.register_node("fluids:water_source", {
	description = S("Water Source"),
	drawtype = "liquid",
	paramtype2 = "flowingliquid",
	leveled = 4,
	waving = 3,
	tiles = {texture_source, texture_source},
	use_texture_alpha = "blend",
	paramtype = "light",
	sunlight_propagates = false,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "fluids:water_flowing",
	liquid_alternative_source = "fluids:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, cools_lava = 1}
})

minetest.register_node("fluids:water_flowing", {
	description = S("Flowing Water"),
	drawtype = "flowingliquid",
	waving = 3,
	tiles = {texture_flowing},
	special_tiles = {texture_flowing, texture_flowing},
	use_texture_alpha = "blend",
	paramtype = "light",
	paramtype2 = "flowingliquid",
	sunlight_propagates = false,
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
	liquid_alternative_flowing = "fluids:water_flowing",
	liquid_alternative_source = "fluids:water_source",
	liquid_viscosity = 1,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1, cools_lava = 1}
})
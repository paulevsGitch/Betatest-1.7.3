worldgen = {}
local path = minetest.get_modpath("worldgen")

if minetest.register_mapgen_script then
	minetest.register_mapgen_script(path .. "/terrain_gen.lua")
else
	dofile(path .. "/terrain_gen.lua")
end

dofile(path .. "/spawnpoint.lua")
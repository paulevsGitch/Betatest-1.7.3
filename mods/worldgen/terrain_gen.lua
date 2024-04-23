local index_table = {}
local node_data = {}
local param2_data = {}
local array_side_dy
local array_side_dz
local tem_hum_maps

local function init_index_table(emin, emax)
	if #index_table > 0 then
		return
	end

	local side = emax.x - emin.x
	local min_side = 16
	local max_side = side - 16

	array_side_dy = side + 1
	array_side_dz = array_side_dy * array_side_dy
	local size = array_side_dy * array_side_dz

	for index = 1, size do
		local index_dec = index - 1

		local x = index_dec % array_side_dy
		if x < min_side or x > max_side then goto index_end end

		local y = math.floor(index_dec / array_side_dy) % array_side_dy
		if y < min_side or y > max_side then goto index_end end

		local z = math.floor(index_dec / array_side_dz)
		if z < min_side or z > max_side then goto index_end end

		table.insert(index_table, index)

		::index_end::
	end
end

local density = {}
local section_count

local min_height_noise_map
local min_height_data = {}
local max_height_noise_map
local max_height_data = {}
local temperature_data = {}
local humidity_data = {}
local volume_noise
local volume_pos = {}

local function get_density(x, y, z, wx, wy, wz)
	if wy < 52 then return 1.0 end
	if wy > 200 then return -1.0 end

	local index_2d = (z - 1) * section_count + x
	local height = min_height_data[index_2d] * 10 + 64
	local den = height - wy

	if den > 0.5 then
		return den
	end

	local gradient = (max_height_data[index_2d] * 50 - wy + 64) / 50
	volume_pos.x = wx
	volume_pos.y = wy
	volume_pos.z = wz
	den = math.max(den, volume_noise:get_3d(volume_pos) + gradient)

	return den
end

local function fill_density(emin, emax)
	if not section_count then
		local side = emax.x - emin.x + 1
		section_count = math.floor((side - 32) / 4) + 2

		local size = vector.new(section_count, section_count, section_count)
		min_height_noise_map = minetest.get_perlin_map({
			offset = 0,
			scale = 1.0,
			spread = vector.new(30, 30, 30),
			seed = 1,
			octaves = 4,
			persistence = 0.5,
			lacunarity = 2.0
		}, size)
		max_height_noise_map = minetest.get_perlin_map({
			offset = 0,
			scale = 1.0,
			spread = vector.new(50, 50, 50),
			seed = 2,
			octaves = 3,
			persistence = 0.5,
			lacunarity = 2.0
		}, size)
		volume_noise = minetest.get_perlin({
			offset = 0,
			scale = 1.0,
			spread = vector.new(40, 40, 40),
			seed = 3,
			octaves = 3,
			persistence = 0.5,
			lacunarity = 2.0,
			flags = "eased"
		})
		size.x = side
		size.y = side
		size.z = side
		tem_hum_maps = environment.make_maps(size)
	end

	local noise_pos = vector.new(math.floor(emin.x / 4), math.floor(emin.z / 4), 0)
	min_height_noise_map:get_2d_map_flat(noise_pos, min_height_data)
	max_height_noise_map:get_2d_map_flat(noise_pos, max_height_data)

	noise_pos.x = emin.x
	noise_pos.y = emin.z
	tem_hum_maps.temperature_noise:get_2d_map_flat(noise_pos, temperature_data)
	tem_hum_maps.humidity_noise:get_2d_map_flat(noise_pos, humidity_data)

	for x = 1, section_count do
		local wx = x * 4 + emin.x + 12
		local density_zy = density[x]
		if not density_zy then
			density_zy = {}
			density[x] = density_zy
		end
		for z = 1, section_count do
			local wz = z * 4 + emin.z + 12
			local density_y = density_zy[z]
			if not density_y then
				density_y = {}
				density_zy[z] = density_y
			end
			for y = 1, section_count do
				local wy = y * 4 + emin.y + 12
				density_y[y] = get_density(x, y, z, wx, wy, wz)
			end
		end
	end
end

local function lerp(a, b, delta)
	return a + delta * (b - a)
end

local AIR_ID = minetest.get_content_id("air")
local STONE_ID = minetest.get_content_id("stones:stone")
local WATER_ID = minetest.get_content_id("fluids:water_source")
local DIRT_ID = minetest.get_content_id("soils:dirt")
local GRASS_ID = minetest.get_content_id("soils:dirt_with_grass")
local SAND_ID = minetest.get_content_id("soils:sand")
local pos = vector.new(0, 0, 0)

local function fill_terrain(vm, emin)
	local x, y, z, x1, y1, z1, x2, y2, z2, dx, dy, dz, a, b, c, d, e, f, g, h, dec_index

	for _, index in ipairs(index_table) do
		dec_index = index - 1
		x = dec_index % array_side_dy - 16
		y = math.floor(dec_index / array_side_dy) % array_side_dy - 16
		z = math.floor(dec_index / array_side_dz) - 16
		x1 = math.floor(x / 4)
		y1 = math.floor(y / 4)
		z1 = math.floor(z / 4)
		dx = x / 4 - x1
		dy = y / 4 - y1
		dz = z / 4 - z1
		x1 = x1 + 1
		y1 = y1 + 1
		z1 = z1 + 1
		x2 = x1 + 1
		y2 = y1 + 1
		z2 = z1 + 1

		a = density[x1][z1][y1]
		b = density[x2][z1][y1]
		c = density[x1][z2][y1]
		d = density[x2][z2][y1]
		e = density[x1][z1][y2]
		f = density[x2][z1][y2]
		g = density[x1][z2][y2]
		h = density[x2][z2][y2]

		a = lerp(a, b, dx)
		b = lerp(c, d, dx)
		c = lerp(e, f, dx)
		d = lerp(g, h, dx)

		a = lerp(a, b, dz)
		b = lerp(c, d, dz)

		if lerp(a, b, dy) > 0 then
			node_data[index] = STONE_ID
		elseif y + emin.y + 16 < 63 then
			node_data[index] = WATER_ID
		end
	end

	for _, index in ipairs(index_table) do
		if node_data[index] == STONE_ID then
			y = math.floor(index / array_side_dy) % array_side_dy + emin.y
			if y < 64 then
				local above = node_data[index + array_side_dy * 3]
				if above == WATER_ID or above == AIR_ID then
					node_data[index] = SAND_ID
				end
			elseif node_data[index + array_side_dy] == AIR_ID then
				if math.random(100) == 1 then
					dec_index = index - 1
					pos.x = (dec_index % array_side_dy) + emin.x
					pos.z = math.floor(dec_index / array_side_dz) + emin.z
					pos.y = y + 1
					trees.make_tree(vm, pos, node_data)
					node_data[index] = DIRT_ID
				else
					node_data[index] = GRASS_ID
					dec_index = index - 1
					x = (dec_index % array_side_dy)
					z = math.floor(dec_index / array_side_dz)
					dec_index = z * array_side_dy + x + 1
					local tem = math.clamp(math.floor((temperature_data[dec_index] * 0.5 + 0.5) * 16), 0, 15)
					local hum = math.clamp(math.floor((humidity_data[dec_index] * 0.5 + 0.5) * 16), 0, 15)
					param2_data[index] = hum * 16 + tem
				end
			elseif node_data[index + array_side_dy * 3] == AIR_ID then
				node_data[index] = DIRT_ID
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, blockseed)
	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	vm:get_data(node_data)
	vm:get_param2_data(param2_data)
	init_index_table(emin, emax)
	fill_density(emin, emax)
	fill_terrain(vm, emin)
	vm:set_data(node_data)
	vm:set_param2_data(param2_data)
	vm:write_to_map()
	minetest.fix_light(emin, emax)
end)
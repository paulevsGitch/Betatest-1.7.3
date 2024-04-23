local temperature_params = {
	offset = 0,
	scale = 1,
	spread = vector.new(100, 100, 100),
	seed = 123,
	octaves = 3,
	persistence = 0.7
}

local humidity_params = {
	offset = 0,
	scale = 1,
	spread = vector.new(100, 100, 100),
	seed = 321,
	octaves = 3,
	persistence = 0.7
}

function environment.make_noises()
	local temperature_noise = minetest.get_perlin(temperature_params)
	local humidity_noise = minetest.get_perlin(humidity_params)
	local vec_2d = {x = 0, y = 0}
	return {
		get_temperature = function (pos)
			vec_2d.x = pos.x
			vec_2d.y = pos.z
			local val = math.floor((temperature_noise:get_2d(vec_2d) * 0.5 + 0.5) * 16)
			return math.clamp(val, 0, 15)
		end,
		get_humidity = function (pos)
			vec_2d.x = pos.x
			vec_2d.y = pos.z
			local val = math.floor((humidity_noise:get_2d(vec_2d) * 0.5 + 0.5) * 16)
			return math.clamp(val, 0, 15)
		end
	}
end

function environment.make_maps(size)
	return {
		temperature_noise = minetest.get_perlin_map(temperature_params, size),
		humidity_noise = minetest.get_perlin_map(humidity_params, size)
	}
end
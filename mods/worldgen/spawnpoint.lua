local storage = minetest.get_mod_storage()
local spawn_pos = minetest.string_to_pos(storage:get("world_spawn_pos") or "")

local pos_2d = {x = 0, y = 0}

local function get_density(pos, min_height_noise, max_height_noise, volume_noise)
	if pos.y < 52 then return 1.0 end
	if pos.y > 200 then return -1.0 end

	pos_2d.x = pos.x / 4
	pos_2d.y = pos.z / 4

	local height = min_height_noise:get_2d(pos_2d) * 10 + 64
	local density = height - pos.y

	if density > 0.5 then return density end

	local gradient = (max_height_noise:get_2d(pos_2d) * 50 - pos.y + 64) / 50
	density = math.max(density, volume_noise:get_3d(pos) + gradient)

	return density
end

local function update_spawn()
	local min_height_noise = minetest.get_perlin({
		offset = 0,
		scale = 1.0,
		spread = vector.new(30, 30, 30),
		seed = 1,
		octaves = 4,
		persistence = 0.5,
		lacunarity = 2.0
	})

	local max_height_noise = minetest.get_perlin({
		offset = 0,
		scale = 1.0,
		spread = vector.new(50, 50, 50),
		seed = 2,
		octaves = 3,
		persistence = 0.5,
		lacunarity = 2.0
	})

	local volume_noise = minetest.get_perlin({
		offset = 0,
		scale = 1.0,
		spread = vector.new(40, 40, 40),
		seed = 3,
		octaves = 3,
		persistence = 0.5,
		lacunarity = 2.0,
		flags = "eased"
	})

	spawn_pos = vector.new(0, 256, 0)
	for _ = 1, 1000 do
		spawn_pos.x = math.random(-128, 128)
		spawn_pos.z = math.random(-128, 128)
		local density = get_density(spawn_pos, min_height_noise, max_height_noise, volume_noise)
		if density < 0.0 then
			while density < 0.0 and spawn_pos.y > 63 do
				spawn_pos.y = spawn_pos.y - 4
				density = get_density(spawn_pos, min_height_noise, max_height_noise, volume_noise)
			end
			spawn_pos.y = spawn_pos.y + 2
			goto break_search
		end
	end
	::break_search::
	minetest.log("Spawn Pos At: " .. spawn_pos.x .. " " .. spawn_pos.y .. " " .. spawn_pos.z)
	storage:set_string("world_spawn_pos", minetest.pos_to_string(spawn_pos))
end

minetest.register_on_respawnplayer(function(player)
	update_spawn()
	player:set_pos(spawn_pos)
	return true
end)

minetest.register_on_joinplayer(function(player, last_login)
	if not last_login then
		update_spawn()
		player:set_pos(spawn_pos)
	end
end)
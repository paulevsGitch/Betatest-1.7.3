local node_data = {}

trees.make_tree = function(vm, pos, nodes)
	local height = math.random(3, 5)

	local log_id = minetest.get_content_id("trees:oak_log")
	local leaves_id = minetest.get_content_id("trees:oak_leaves")
	local air_id = minetest.get_content_id("air")

	local pmin, pmax = vm:get_emerged_area()
	local va = VoxelArea(pmin, pmax)

	local index = 0

	for y = 0, height do
		index = va:index(pos.x, pos.y + y, pos.z)
		if nodes[index] == air_id then
			nodes[index] = log_id
		end
	end

	for y = height - 1, height do
		for x = -2, 2 do
			for z = -2, 2 do
				if math.abs(x) ~= 2 or math.abs(z) ~= 2 then
					index = va:index(pos.x + x, pos.y + y, pos.z + z)
					if nodes[index] == air_id then
						nodes[index] = leaves_id
					end
				end
			end
		end
	end

	for x = -1, 1 do
		for z = -1, 1 do
			index = va:index(pos.x + x, pos.y + height + 1, pos.z + z)
			if nodes[index] == air_id then
				nodes[index] = leaves_id
			end
		end
	end

	for x = -1, 1 do
		for z = -1, 1 do
			if math.abs(x) ~= 1 or math.abs(z) ~= 1 then
				index = va:index(pos.x + x, pos.y + height + 2, pos.z + z)
				if nodes[index] == air_id then
					nodes[index] = leaves_id
				end
			end
		end
	end
end

minetest.register_chatcommand("tree", {
	description = "Grows a tree",
	func = function(name, param)
		local player = minetest.get_player_by_name(name)

		local pos = player:get_pos()
		pos.x = math.round(pos.x)
		pos.y = math.round(pos.y)
		pos.z = math.round(pos.z)

		local pmin = vector.new(pos)
		local pmax = vector.new(pos)

		pmin.x = pos.x - 2
		pmin.z = pos.z - 2
		pmax.x = pos.x + 2
		pmax.z = pos.z + 2
		pmax.y = pos.y + 16
		
		local vm = minetest.get_voxel_manip(pmin, pmax)
		
		vm:get_data(node_data)
		trees.make_tree(vm, pos, node_data)
		vm:set_data(node_data)
		vm:write_to_map(true)

		return true, "Placed tree at " .. pos.x .. " " .. pos.y .. " " .. pos.z
	end
})
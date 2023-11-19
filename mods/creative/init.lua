local PLAYERS = {}
local DELAY = 100000 -- Delay in microseconds

local function is_creative(player)
	local name = player:get_player_name()
	return minetest.is_creative_enabled(name)
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
	if is_creative(placer) then
		return true
	end
end)

minetest.register_on_punchnode(function(pos, node, puncher, pointed_thing)
	if is_creative(puncher) then
		local name = puncher:get_player_name()
		local cacheTime = PLAYERS[name] or 0
		local time = minetest.get_us_time()
		if time > cacheTime then
			minetest.remove_node(pos)
		end
		PLAYERS[name] = time + DELAY
	end
end)

minetest.register_on_leaveplayer(function(player, timed_out)
	PLAYERS[player:get_player_name()] = nil
end)
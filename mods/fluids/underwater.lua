local playersWaterData = {}
local skyColor = {r = 255, g = 255, b = 255, a = 255}

local waterColor = {}
waterColor[15] = {r = 49, g = 179, b = 187, a = 255}
waterColor[0] = {r = 22, g = 56, b = 72, a = 255}

local function lerp(a, b, mix)
	return a + (b - a) * mix
end

for i = 1, 14 do
	local mix = i / 15
	local r = lerp(waterColor[0].r, waterColor[15].r, mix)
	local g = lerp(waterColor[0].g, waterColor[15].g, mix)
	local b = lerp(waterColor[0].b, waterColor[15].b, mix)
	waterColor[i] = {r = r, g = g, b = b, a = 255}
end

minetest.register_globalstep(function(dtime)
	local players = minetest.get_connected_players()
	for index, player in ipairs(players) do
		local pos = player:get_pos()
		local offset = player:get_eye_offset()
		
		if offset.y ~= 0 then
			pos.x = pos.x + offset.x
			pos.y = pos.y + offset.y
			pos.z = pos.z + offset.z
		else
			pos.y = pos.y + 1.625
		end
		
		local node = minetest.get_node(pos)
		local isWater = minetest.get_node_group(node.name, "water") > 0
		local light = minetest.get_natural_light(pos) or 15
		
		local name = player:get_player_name()
		local playerData = playersWaterData[name]
		
		if playerData == nil then
			playerData = {isWater = false, light = 15}
			playersWaterData[name] = playerData
		end
		
		local changeLight = playerData.light ~= light
		if playerData.isWater ~= isWater or changeLight then
			if isWater then
				player:set_sky(waterColor[light], "plain")
				-- minetest.chat_send_all("In water")
			else
				player:set_sky(skyColor, "regular")
				-- minetest.chat_send_all("Out of water")
			end
			playerData.isWater = isWater
			playerData.light = light
		end
	end
end)

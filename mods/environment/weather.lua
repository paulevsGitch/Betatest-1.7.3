minetest.register_on_joinplayer(function(player)
	player:set_clouds({
		density = 0.4,
		color = "#FFFFFFCC",
		height = 200,
		thickness = 16
	})
	player:set_sky({
		--base_color = "#FF0000"
		sky_color = {
			day_sky = "#92a5ff",
			day_horizon = "#b0c6ff"--,
			-- Not working, see: https://github.com/minetest/minetest/issues/9508
			--night_sky = "#030306",
			--night_horizon = "#0c0f19",
			--dawn_sky = "#43638f",
			--dawn_horizon = "#ac6b58"
		},
		fog = {
			fog_color = "b0c6ff"
		}
	})
	player:set_sun({
		texture = "environment_sun.png",
		scale = 2.5
	})
end)
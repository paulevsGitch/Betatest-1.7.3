minetest.register_on_mods_loaded(function()
	-- override hand item
	minetest.override_item("", {
		range = 5,
		tool_capabilities = MINING_LEVELS.make_tool_capabilities(nil, MINING_LEVELS.LEVELS.HAND)
	})
end)
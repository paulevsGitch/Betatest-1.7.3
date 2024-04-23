math.clamp = function (val, val_min, val_max)
	if val < val_min then
		return val_min
	elseif val > val_max then
		return val_max
	else
		return val
	end
end
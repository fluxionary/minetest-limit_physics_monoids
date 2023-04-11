limit_physics_monoids = fmod.create()

local log = math.log
local pow = math.pow
local tanh = math.tanh

local folders = {
	add = function(t, x)
		for _, v in pairs(t) do
			x = x + v
		end
		return x
	end,
	max = function(t, x)
		for _, v in pairs(t) do
			x = x > v and x or v
		end
		return x
	end,
	multiply = function(t, x)
		for _, v in pairs(t) do
			x = x * v
		end
		return x
	end,
}

local limiters = {
	none = function(x)
		return x
	end,
	gamma = function(x, param_1)
		return pow(x, param_1)
	end,
	tanh = function(x, param_1)
		return (tanh((x - 1) / param_1) - tanh(-1 / param_1)) / -tanh(-1 / param_1)
	end,
	log__n = function(x, param_1, param_2)
		return (log(x + 1) * pow(log(param_1 * x + 1), param_2) / (log(2) * pow(log(param_1 + 1), param_2)))
	end,
}

local s = limit_physics_monoids.settings

local speed_folder = folders[s.speed_folder]
local speed_folder_initial = s.speed_folder_initial
local speed_limiter = limiters[s.speed_limiter]
local speed_param_1 = s.speed_param_1
local speed_param_2 = s.speed_param_2

local jump_folder = folders[s.jump_folder]
local jump_folder_initial = s.jump_folder_initial
local jump_limiter = limiters[s.jump_limiter]
local jump_param_1 = s.jump_param_1
local jump_param_2 = s.jump_param_2

local gravity_folder = folders[s.gravity_folder]
local gravity_folder_initial = s.gravity_folder_initial
local gravity_limiter = limiters[s.gravity_limiter]
local gravity_param_1 = s.gravity_param_1
local gravity_param_2 = s.gravity_param_2

function player_monoids.speed.def.fold(t)
	return speed_folder(t, speed_folder_initial)
end

function player_monoids.speed.def.apply(multiplier, player)
	local ov = player:get_physics_override()
	ov.speed = speed_limiter(multiplier, speed_param_1, speed_param_2)
	player:set_physics_override(ov)
end

function player_monoids.jump.def.fold(t)
	return jump_folder(t, jump_folder_initial)
end

function player_monoids.jump.def.apply(multiplier, player)
	local ov = player:get_physics_override()
	ov.jump = jump_limiter(multiplier, jump_param_1, jump_param_2)
	player:set_physics_override(ov)
end

function player_monoids.gravity.def.fold(t)
	return gravity_folder(t, gravity_folder_initial)
end

function player_monoids.gravity.def.apply(multiplier, player)
	local ov = player:get_physics_override()
	ov.gravity = gravity_limiter(multiplier, gravity_param_1, gravity_param_2)
	player:set_physics_override(ov)
end

limit_physics_monoids = fmod.create()

local log = math.log
local pow = math.pow
local tanh = math.tanh

--[[

]]
local limiters = {
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

local speed_limiter = limiters[limit_physics_monoids.settings.speed_limiter]
local speed_param_1 = limit_physics_monoids.settings.speed_param_1
local speed_param_2 = limit_physics_monoids.settings.speed_param_2

local jump_limiter = limiters[limit_physics_monoids.settings.jump_limiter]
local jump_param_1 = limit_physics_monoids.settings.jump_param_1
local jump_param_2 = limit_physics_monoids.settings.jump_param_2

local gravity_limiter = limiters[limit_physics_monoids.settings.gravity_limiter]
local gravity_param_1 = limit_physics_monoids.settings.gravity_param_1
local gravity_param_2 = limit_physics_monoids.settings.gravity_param_2

function player_monoids.speed.def.apply(multiplier, player)
	local ov = player:get_physics_override()
	ov.speed = speed_limiter(multiplier, speed_param_1, speed_param_2)
	player:set_physics_override(ov)
end

function player_monoids.jump.def.apply(multiplier, player)
	local ov = player:get_physics_override()
	ov.jump = jump_limiter(multiplier, jump_param_1, jump_param_2)
	player:set_physics_override(ov)
end

function player_monoids.gravity.def.apply(multiplier, player)
	local ov = player:get_physics_override()
	ov.gravity = gravity_limiter(multiplier, gravity_param_1, gravity_param_2)
	player:set_physics_override(ov)
end

futil.check_version({ year = 2023, month = 8, day = 17 }) -- limiters now here

limit_physics_monoids = fmod.create()

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

local s = limit_physics_monoids.settings

local speed_folder = assert(folders[s.speed_folder], "unknown folder " .. s.speed_folder)
local speed_folder_initial = s.speed_folder_initial
local speed_limiter = assert(futil.limiters[s.speed_limiter], "unknown limiter " .. s.speed_limiter)
local speed_param_1 = s.speed_param_1
local speed_param_2 = s.speed_param_2

local jump_folder = assert(folders[s.jump_folder], "unknown folder " .. s.jump_folder)
local jump_folder_initial = s.jump_folder_initial
local jump_limiter = assert(futil.limiters[s.jump_limiter], "unknown limiter " .. s.jump_limiter)
local jump_param_1 = s.jump_param_1
local jump_param_2 = s.jump_param_2

local gravity_folder = assert(folders[s.gravity_folder], "unknown folder " .. s.gravity_folder)
local gravity_folder_initial = s.gravity_folder_initial
local gravity_limiter = assert(futil.limiters[s.gravity_limiter], "unknown limiter " .. s.gravity_limiter)
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


local circles = {}
-- Calculate the values for the segments of the circles
do
	local sqrt2 = math.sqrt(2) * 0.5
	local rad90 = math.rad(90)
	local pos = vector.new(sqrt2, 0, sqrt2)
	local vel = vector.new((1 - sqrt2) * 2, 0, -sqrt2)
	local acc = vector.new((1 - sqrt2) * -2, 0, 0)
	local axes = {
		x = vector.new(1, 0, 0),
		y = vector.new(0, 1, 0),
		z = vector.new(0, 0, 1),
	}
	for _,axis in ipairs({"y", "x", "z"}) do  -- This order is important
		circles[axis] = {}
		if axis == "x" then
			pos = vector.rotate_around_axis(pos, axes.z, rad90)
			vel = vector.rotate_around_axis(vel, axes.z, rad90)
			acc = vector.rotate_around_axis(acc, axes.z, rad90)
		elseif axis == "z" then
			pos = vector.rotate_around_axis(pos, axes.y, rad90)
			vel = vector.rotate_around_axis(vel, axes.y, rad90)
			acc = vector.rotate_around_axis(acc, axes.y, rad90)
		end
		for i=1, 4 do
			circles[axis][i] = {
				pos = vector.rotate_around_axis(pos, axes[axis], rad90 * i),
				vel = vector.rotate_around_axis(vel, axes[axis], rad90 * i),
				acc = vector.rotate_around_axis(acc, axes[axis], rad90 * i),
			}
		end
	end
end

local function get_valid_options(options)
	if type(options) ~= "table" then
		options = {}
	end
	local color = options.color or vizlib.default_color
	for _,c in ipairs(vizlib.colors) do
		if c.name == color then
			color = c.hex
		end
	end
	local time = options.infinite and 0 or 10
	local density = options.infinite and 1 or 10
	local name
	local t = type(options.player)
	if t == "string" then
		name = options.player
	elseif t == "userdata" or t == "table" then
		name = options.player:get_player_name()
	end
	return color, name, time, density
end

--------------------------------------------------
-- API Functions. See API.md for details.
--------------------------------------------------

function vizlib.select_color()
	return vizlib.colors[math.random(24)].hex
end

function vizlib.random_color()
	local r = math.random(0, 255)
	local g = math.random(0, 255)
	local b = math.random(0, 255)
	return string.format("#%02x%02x%02x", r, g, b)
end

function vizlib.clear_particles(ids)
	if type(ids) ~= "table" then
		ids = {ids}
	end
	for _,id in pairs(ids) do
		minetest.delete_particlespawner(id)
	end
end

function vizlib.draw_circle(pos, radius, axis, options)
	local color, name, time, density = get_valid_options(options)
	local ids, vel, acc = {}
	for _,segment in pairs(circles[axis] or {}) do
		pos = vector.add(pos, vector.multiply(segment.pos, radius))
		vel = vector.multiply(segment.vel, radius)
		acc = vector.multiply(segment.acc, radius)
		table.insert(ids, minetest.add_particlespawner({
			playername = name,
			time = time,
			amount = radius * density * 8,
			minpos = pos,
			maxpos = pos,
			minvel = vel,
			maxvel = vel,
			minacc = acc,
			maxacc = acc,
			minexptime = 2,
			maxexptime = 2,
			texture = "vizlib_particle.png^[multiply:"..color,
			glow = 14,
		}))
	end
	return ids
end

function vizlib.draw_sphere(pos, radius, options)
	local ids = {}
	for axis in pairs(circles) do
		for _,id in pairs(vizlib.draw_circle(pos, radius, axis, options)) do
			table.insert(ids, id)
		end
	end
	return ids
end

function vizlib.draw_line(pos1, pos2, options)
	local color, name, time, density = get_valid_options(options)
	local distance = vector.distance(pos1, pos2)
	local dir = vector.direction(pos1, pos2)
	local vel = vector.multiply(dir, distance * 0.5)
	local expt = 2.0
	if distance > 40 then
		-- Increase exptime instead of velocity
		vel = vector.multiply(dir, 20.0)
		expt = distance / 20.0
	end
	return minetest.add_particlespawner({
		playername = name,
		time = time,
		amount = distance * density * 2,
		minpos = pos1,
		maxpos = pos1,
		minvel = vel,
		maxvel = vel,
		minexptime = expt,
		maxexptime = expt,
		texture = "vizlib_particle.png^[multiply:"..color,
		glow = 14,
	})
end

function vizlib.draw_square(pos, radius, axis, options)
	local p1, p2, p3, p4
	if axis == "x" then
		p1 = vector.add(pos, vector.new(0, -radius, -radius))
		p2 = vector.add(pos, vector.new(0,  radius, -radius))
		p3 = vector.add(pos, vector.new(0,  radius,  radius))
		p4 = vector.add(pos, vector.new(0, -radius,  radius))
	elseif axis == "y" then
		p1 = vector.add(pos, vector.new(-radius, 0, -radius))
		p2 = vector.add(pos, vector.new( radius, 0, -radius))
		p3 = vector.add(pos, vector.new( radius, 0,  radius))
		p4 = vector.add(pos, vector.new(-radius, 0,  radius))
	elseif axis == "z" then
		p1 = vector.add(pos, vector.new(-radius, -radius, 0))
		p2 = vector.add(pos, vector.new( radius, -radius, 0))
		p3 = vector.add(pos, vector.new( radius,  radius, 0))
		p4 = vector.add(pos, vector.new(-radius,  radius, 0))
	end
	return {
		vizlib.draw_line(p1, p2, options),
		vizlib.draw_line(p2, p3, options),
		vizlib.draw_line(p3, p4, options),
		vizlib.draw_line(p4, p1, options),
	}
end

function vizlib.draw_cube(pos, radius, options)
	local p1 = vector.add(pos, vector.new(-radius,  radius, -radius))
	local p2 = vector.add(pos, vector.new( radius,  radius, -radius))
	local p3 = vector.add(pos, vector.new( radius,  radius,  radius))
	local p4 = vector.add(pos, vector.new(-radius,  radius,  radius))
	local p5 = vector.add(pos, vector.new(-radius, -radius, -radius))
	local p6 = vector.add(pos, vector.new( radius, -radius, -radius))
	local p7 = vector.add(pos, vector.new( radius, -radius,  radius))
	local p8 = vector.add(pos, vector.new(-radius, -radius,  radius))
	return {
		-- Top
		vizlib.draw_line(p1, p2, options),
		vizlib.draw_line(p2, p3, options),
		vizlib.draw_line(p3, p4, options),
		vizlib.draw_line(p4, p1, options),
		-- Bottom
		vizlib.draw_line(p5, p6, options),
		vizlib.draw_line(p6, p7, options),
		vizlib.draw_line(p7, p8, options),
		vizlib.draw_line(p8, p5, options),
		-- Sides
		vizlib.draw_line(p1, p5, options),
		vizlib.draw_line(p2, p6, options),
		vizlib.draw_line(p3, p7, options),
		vizlib.draw_line(p4, p8, options),
	}
end

function vizlib.draw_area(pos1, pos2, options)
	local minp, maxp = {}, {}
	for _,c in pairs({"x", "y", "z"}) do
		minp[c] = math.min(pos1[c], pos2[c])
		maxp[c] = math.max(pos1[c], pos2[c])
	end
	local p1 = vector.new(minp.x, maxp.y, minp.z)
	local p2 = vector.new(maxp.x, maxp.y, minp.z)
	local p3 = vector.new(maxp.x, maxp.y, maxp.z)
	local p4 = vector.new(minp.x, maxp.y, maxp.z)
	local p5 = vector.new(minp.x, minp.y, minp.z)
	local p6 = vector.new(maxp.x, minp.y, minp.z)
	local p7 = vector.new(maxp.x, minp.y, maxp.z)
	local p8 = vector.new(minp.x, minp.y, maxp.z)
	return {
		-- Top
		vizlib.draw_line(p1, p2, options),
		vizlib.draw_line(p2, p3, options),
		vizlib.draw_line(p3, p4, options),
		vizlib.draw_line(p4, p1, options),
		-- Bottom
		vizlib.draw_line(p5, p6, options),
		vizlib.draw_line(p6, p7, options),
		vizlib.draw_line(p7, p8, options),
		vizlib.draw_line(p8, p5, options),
		-- Sides
		vizlib.draw_line(p1, p5, options),
		vizlib.draw_line(p2, p6, options),
		vizlib.draw_line(p3, p7, options),
		vizlib.draw_line(p4, p8, options),
	}
end

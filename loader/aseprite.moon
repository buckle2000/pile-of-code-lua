-- Copyright 2016-2017 buckle2000
-- MIT License

json = require (PILE_OF_CODE_BASE or '') .. "json"

class Frame
	new: (@quad, @duration) =>

class Tag
	new: (from, to, direction) =>
		@reset!

	@all = (frame_count, dir='forward') ->
		@(1, frame_count, dir)

--TODO
function Tag:reset()
	local dir = self.direction
	if dir == "forward" then
		self.current = self.from
	elseif dir == "reverse" then
		self.current = self.to
	elseif dir == "pingpong" then
		self.current = self.from
		self._pingpong = false
	end
end

function Tag:next()
	local cframe = self.current
	local dir = self.direction
	local pingpong = dir == "pingpong"
	if dir == "forward" or (pingpong and not self._pingpong) then
		cframe = cframe + 1
		if cframe > self.to then
			if pingpong then
				self._pingpong = true
				cframe = self.to - 1
			else
				cframe = self.from
			end
		end
	elseif dir == "reverse" or (pingpong and self._pingpong) then
		cframe = cframe - 1
		if cframe < self.from then
			if pingpong then
				self._pingpong = false
				cframe = self.from + 1
			else
				cframe = self.to
			end
		end
	else
		error("Animation play direction "..dir.." is not supported.")
	end
	self.current = cframe
	return cframe
end

--#################################################

local Animation = Class()

--- Animation
-- animation class
-- @field _all_tag play all frame

--- Constructor
-- @param partial_path something like 'path/to/image'
--   will load 'path/to/image.png'
--   and 'path/to/image.json' (must exist)
function Animation:init(img_name)
	do
		local gcp = self.entity.graphics
		assert(not gcp, "Already has graphics component.")
		self.entity:add("graphics", love.graphics.newImage(CONST.PATH_IMAGE .. img_name .. ".png"))
	end

	-- load config
	local cfg = json.decode(love.filesystem.read(CONST.PATH_IMAGE .. img_name .. ".json"))
	local sw, sh = cfg.meta.size.w, cfg.meta.size.h
	self.frames = {}
	for i,frame in ipairs(cfg.frames) do
		self.frames[i] = Frame(
			love.graphics.newQuad(frame.frame.x, frame.frame.y, frame.frame.w, frame.frame.h, sw, sh),
			frame.duration / 1000
		)
	end
	self.tags = {}
	for i,tag in ipairs(cfg.meta.frameTags) do
		self.tags[tag.name] = Tag(tag.from + 1, tag.to + 1, tag.direction) -- +1 because lua index starts at 1
	end
	self._all_tag = Tag.all(#self.frames)
	self:set_tag()
	self.acc_t = 0
end

function Animation:get_frame()
	return self.frames[self.cframe]
end

function Animation:get_tag()
	if self.ctag==nil then
		return self._all_tag
	else
		return self.tags[self.ctag]
	end
end

function Animation:step()
	self.cframe = self:get_tag():next()
end

-- @param name tag name
--   if 'name' is nil, play all frames
function Animation:set_tag(name)
	local tag
	if name==nil then
		tag = self._all_tag
	else
		tag = self.tags[name]
		assert(tag, "Tag "..name.." does not exist.")
	end
	tag:reset()
	self.cframe = tag.current
	self.ctag = name
end

function Animation:update(dt)
	local acc = self.acc_t
	acc = acc + dt
	local frame = self:get_frame()
	if acc > frame.duration then
		acc = acc - frame.duration
		self:step()
	end
	self.acc_t = acc
end

return {
	Animation = Animation,
	Tag = Tag,
	Frame = Frame,
}

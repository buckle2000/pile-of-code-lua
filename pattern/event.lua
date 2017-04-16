--[[
Modified version of original hump/signal

Copyright (c) 2012-2013 Matthias Richter
Copyright (c) 2017 buckle2000

MIT/X11 License
]]--

-- TODO use "set" ds to optimize

local Registry = {}

function Registry:register(s, f)
  if self[s]==nil then
    self[s] = {}
  end
  self[s][f] = f
  return f
end

function Registry:emit(s, ...)
  if self[s]~=nil then
    for f in pairs(self[s]) do
      f(...)
    end
  end
end

function Registry:remove(s, f)
  self[s][f] = nil
  return f
end

function Registry:clear(s)
  self[s] = nil
end

-- the module
function Registry.new()
  return {
  	_pile_reg      = {},
    register       = function(self, ...) return Registry.register(self._pile_reg, ...) end,
    remove         = function(self, ...) return Registry.remove(self._pile_reg, ...) end,
    emit           = function(self, ...) Registry.emit(self._pile_reg, ...) end,
    clear          = function(self, ...) Registry.clear(self._pile_reg, ...) end,
    reset          = function(self) self._pile_reg = {} end,
  }
end

return Registry

--[[
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
  local registry = {}

  return setmetatable({
    new            = new,
    register       = function(...) return Registry.register(registry, ...) end,
    remove         = function(...) return Registry.remove(registry, ...) end,
    emit           = function(...) Registry.emit(registry, ...) end,
    clear          = function(...) Registry.clear(registry, ...) end,
    reset          = function() registry = {} end,
    get_the_fuck   = function() return registry end,
  })
end

return Registry

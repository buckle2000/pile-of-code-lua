--- Object Pool
-- Copyright © 2011 Josh Tynjala
-- Copyright © 2017 buckle2000
-- Released under the MIT license.
class Pool
  new: =>
    @cache = {}
  
  -- must have
  create_object: =>  
    error("ObjectPool: function `pool:create_object` required.")

  -- max_size: 1000
  -- destroy_object: =>
  -- on_borrow: =>
  -- on_return: =>
    
  borrow_object: () =>
    local object
    if # cache > 0 then
      object = table.remove(cache, 1)
    else
      object = @create_object()
      if object == nil then
        error("ObjectPool:create_object() doesn't return a value")
    if @on_borrow ~= nil then
      @on_borrow(object)
    return object
    
  return_object: (object) =>
    if object == nil then
      return
    if @on_eeturn ~= nil then
      @on_eeturn(object)
    if @maxSize ~= nil and # cache >= @maxSize then
      if @destroy_object ~= nil then
        @destroy_object(object)
      return
    table.insert(cache, object)
    
  populate: (size) =>
    if size == nil and @maxSize == nil then
      error("ObjectPool:populate requires size parameter or maxSize property.")
    if size == nil then
      size = @maxSize
    objects = {}
    for i = 1,size do
      table.insert(objects, self:borrow_object())
    for i,object in ipairs(objects) do
      self:return_object(object)
      
  clear: () =>
    while # cache > 0 do
      object = table.remove(cache, 1)
      if @destroy_object ~= nil then
        @destroy_object(object)

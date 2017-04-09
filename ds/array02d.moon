-- 0-based 2D array

Array = require (PILE_OF_CODE_BASE or '') .. "ds.Array"

class Array2D
  -- not auto init
  new: (@width, @height) =>
    @size = width * height
    @data = Array @size

  index: (x, y) =>
    x + @width * y

  get: (x, y) =>
    @data[@index(x, y)]

  set: (x, y, value) =>
    @data[@index(x, y)] = value

  __tostring: =>
    tostring @data

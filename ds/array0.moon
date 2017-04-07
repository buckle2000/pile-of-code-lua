iter_helper = (t, index) ->
  index += 1
  if index == t.n
    return
  return index, t[index]


class Array
  new: (size=0, default_value) =>
    if default_value ~= nil
      for i=0,size-1
        @[i] = default_value
    @n = size

  @from_pack = (...) ->
    arr = @!
    arr.n = select('#', ...)
    for i=1,arr.n
      arr[i-1] = select(i, ...)
    arr

  @from_table = (t) ->
    arr = @!
    arr.n = table.maxn(t)
    for i=1,arr.n
      arr[i-1] = t[i]
    arr

  @from_range = (head,tail) ->
    arr = @!
    for i=head,tail
      arr\push i
    arr

  insert: (pos, value) =>
    for i=@n-1,pos,-1
      @[i+1] = @[i]
    @[pos] = value
    @n += 1
    return

  remove: (pos) =>
    assert pos >= 0 and pos < @n,
      "Index out of bounds. #{pos}"
    @n -= 1
    value = @[pos]
    for i=pos,@n
      @[i] = @[i+1]
    value

  push: (value) =>
    @n += 1
    @[@n-1] = value
    return

  pop: =>
    value = @[@n]
    @[@n] = nil
    @n -= 1
    value

  iter: =>
    iter_helper, @, -1

  maxn: =>
    @n

  concat: =>
    -- TODO

  sort: =>
    -- TODO

  -- __index: (index) =>
  --     assert(0 <= index and index < @n,
  --       "Index out of bounds. #{index}")
  --     rawget @, index

  -- __newindex: (index, v) =>
  --   if index == @n
  --     @n += 1
  --     rawset @, index, v
  --   else
  --     assert(0 <= index and index < @n,
  --       "Index out of bounds. #{index}")
  --   nil

  __tostring: =>
    if @n == 0
      "{}"
    else
      values = tostring(@[0])
      for i=1,@n-1
        values ..= "," .. tostring(@[i])
      "{#{values}} #{@n}"

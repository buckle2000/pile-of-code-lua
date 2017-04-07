ffi = require "ffi"
ffi_istype   = ffi.istype
ffi_metatype = ffi.metatype

bit = require "bit"
bit_xor    = bit.bxor
bit_lshift = bit.lshift
bit_rshift = bit.rshift

math = require "math"
sqrt  = math.sqrt
atan2 = math.atan2

local *

is_number = (n) -> type(n) == "number"
is_vector2 = (n) -> ffi_istype vector2, n

hashxy = (x, y) ->
  -- the easier the better
  x * 1e7 + y
  
index_mt = {
  clone: (v) ->
    vector2 v.x, v.y
  euclidean: (v) ->
    vector2 v\len!, atan2(v.x, v.y)
  ieuclidean: (v) ->
    v.x = v\len!
    v.y = atan2(v.x, v.y)
  polar: (v) ->
    vector2 v.x * cos(v.y), v.x * sin(v.y)
  ipolar: (v) ->
    v.x = v.x * cos(v.y)
    v.y = v.x * sin(v.y)

  set: (a, b) ->
    a.x = b.x
    a.y = b.y
  setxy: (v, x, y) ->
    v.x = x
    v.y = y
  unpack: (v) ->
    v.x, v.y

  hash: (v) ->
    hashxy v.x, v.y
  length: (v) ->
    sqrt v.x^2 + v.y^2
  length2: (v) ->
    v.x^2 + v.y^2
  dot: (a, b) ->
    a.x*b.x + a.y*b.y
  cross: (a, b) ->
    a.x*b.y - a.y*b.x
  distance: (a, b) ->
    sqrt (a.x-b.x)^2 + (a.y-b.y)^2
  distance2: (a, b) ->
    (a.x-b.x)^2 + (a.y-b.y)^2
  normalize: (v) ->
    l = v\length!
    assert l>0, "Vec2: trying to normalize (0,0)."
    vector2 v.x/l, v.y/l
  inormalize: (v) ->
    l = v\length!
    assert l>0, "Vec2: trying to normalize (0,0)."
    v.x /= l
    v.y /= l

  add: (a, b) ->
    vector2 a.x+b.x, a.y+b.y
  sub: (a, b) ->
    vector2 a.x-b.x, a.y-b.y
  mul: (a, b) ->
    if is_number a
      vector2 a * b.x, a * b.y
    elseif is_number b
      vector2 a.x * b, a.y * b
    else
      error "Vec2: please use 'dot(a,b)'."
  div: (a, b) ->
    assert is_number(b), "Vec2: can only divide by number."
    vector2 a.x/b, a.y/b
  unm: (v) ->
    vector2 -v.x, -v.y
  eq: (a, b) ->
    is_vector2(a) and
    is_vector2(b) and
    a.x == b.x and a.y == b.y
  tostring: (v) ->
    "(#{v.x},#{v.y})"
  iadd: (a, b) ->
    a.x += b.x
    a.y += b.y
  isub: (a, b) ->
    a.x -= b.x
    a.y -= b.y
  imul: (a, b) ->
    a.x *= b
    a.y *= b
  idiv: (a, b) ->
    a.x /= b
    a.y /= b
  iunm: (v) ->
    v.x = -v.x
    v.y = -v.y
}

mt = {
  __add:      index_mt.add
  __sub:      index_mt.sub
  __mul:      index_mt.mul
  __div:      index_mt.div
  __unm:      index_mt.unm
  __eq:       index_mt.eq
  __tostring: index_mt.tostring
  __index:    index_mt
}

vector2 = ffi_metatype "struct { double x, y; }", mt

setmetatable {
  ctype: vector2
  zero: -> vector2 0, 0
  identity: (n=1) -> vector2 n, n
  from_polar: (d, angle) ->
    vector2 d * cos(angle), d * sin(angle)
  is_a: is_vector2
  hashxy: hashxy
}, {
  __call: (_, ...) -> vector2 ...
  __index: index_mt
}
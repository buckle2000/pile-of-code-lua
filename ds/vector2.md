# Vector2

2-value vector for LuaJIT.

It should be faster and memory friendlier than pure lua implementations.

## API

### module API

**Assume `vec2 = require "vector2"`.**

`ctype`

[ctype](http://luajit.org/ext_ffi_api.html#glossary) of vector2

`zero()` -> vector2

(0, 0)

`identity(n=1)` -> vector2

(n, n)

`from_polar(distance, angle)` -> vector2

turn polar into euclidean

`is_a(object)` -> boolean

is this a vector2?

`hashxy(x, y)` -> number

hash function

### module & instance API

functions for both module and vector instance

e.g. either `vec2.clone(v)` or `v:clone()` will work

#### can be in-place

following functions have in-place version with preceding `i`

e.g. `iadd` is the in-place version of `add`

##### also in metatable

also avaliable with +-*/

e.g. `v1 + v2` is `add(v1, v2)`

`add(v1, v2)`

`sub(v1, v2)`

`mul(v1, v2)`

`div(v1, v2)`

`unm(v)`
-v

`eq(v1, v2)`

`tostring(v)`

`normalize(v)`

`euclidean(v)`
polar to euclidean

`polar(v)`
euclidean to polar

#### others

`hash(v)`

`clone(v)`

`set(v1, v2)`
set v2's value to v1

`setxy(v, x, y)`
set v to (x,y)

`unpack(v)`
return v.x, v.y

`length(v)`
euclidean length

`length2(v)`
length squared

`dot(v1, v2)`
dot product

`cross(v1, v2)`
cross product; sadly, return **number**

`distance(v1, v2)`
euclidean distance

`distance2(v1, v2)`
distance squared
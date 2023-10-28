--- @meta

--- @alias ColorLike ColorInstance | {r: number, g: number, b: number, a: number?} | {[1]: number, [2]: number, [3]: number, [4]: number?}

--- @class ColorInstance
--- @field r number The red component of the color. Range: 0-1.
--- @field g number The green component of the color. Range: 0-1.
--- @field b number The blue component of the color. Range: 0-1.
--- @field a number? The alpha component of the color. Range: 0-1.
--- @field [1] number The red component of the color. Range: 0-1.
--- @field [2] number The green component of the color. Range: 0-1.
--- @field [3] number The blue component of the color. Range: 0-1.
--- @field [4] number? The alpha component of the color. Range: 0-1.

--- @class Color
--- @overload fun(r: number, g: number, b: number): ColorInstance
--- @overload fun(r: number, g: number, b: number, a: number): ColorInstance
--- @overload fun(t: ColorLike): ColorInstance
Color = {}

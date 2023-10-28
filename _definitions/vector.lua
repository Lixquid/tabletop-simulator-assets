--- @meta

--- @alias VectorLike Vector | {x: number, y: number, z: number} | {[1]: number, [2]: number, [3]: number}

--- @class VectorInstance
--- @field x number The X component of the vector.
--- @field y number The Y component of the vector.
--- @field z number The Z component of the vector.
--- @field [1] number The X component of the vector.
--- @field [2] number The Y component of the vector.
--- @field [3] number The Z component of the vector.

--- @class Vector
--- @overload fun(x: number, y: number, z: number): VectorInstance
--- @overload fun(t: VectorLike): VectorInstance
Vector = {}

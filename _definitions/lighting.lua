--- @meta

--- Lighting, a static global class, is the in-game light of the map. It allows
--- you to modify the lighting of the instance in the same way that the in-game
--- lighting menu does.
Lighting = {
    --- The strength of ambient light. Range: 0-4.
    --- @type number
    ambient_intensity = 0,

    --- The source of ambient light. 1 = background, 2 = gradient.
    --- @type number
    ambient_type = 0,

    --- The strength of the directional light shining down in the scene. Range: 0-4.
    --- @type number
    light_intensity = 0,

    --- How much the LUT contributes to the light.
    --- @type number
    lut_contribution = 0,

    --- The LUT index of the light. Integer.
    --- @type number
    lut_index = 0,

    --- The URL of the LUT.
    --- @type string
    lut_url = "",

    --- The strength of the reflections from the background. Range: 0-1.
    --- @type number
    reflection_intensity = 0,



    --- Applies pending lighting changes.
    apply = function() end,

    --- Returns color of the gradient equator. Not used if `ambient_type` is 1.
    --- @return ColorInstance
    --- @nodiscard
    getAmbientEquatorColor = function() end,

    --- Sets the color of the gradient equator. Not used if `ambient_type` is 1.
    --- @param tint ColorLike
    --- @return boolean
    setAmbientEquatorColor = function(tint) end,

    --- Returns color of the gradient ground. Not used if `ambient_type` is 1.
    --- @return ColorInstance
    --- @nodiscard
    getAmbientGroundColor = function() end,

    --- Sets the color of the gradient ground. Not used if `ambient_type` is 1.
    --- @param tint ColorLike
    --- @return boolean
    setAmbientGroundColor = function(tint) end,

    --- Returns color of the gradient sky. Not used if `ambient_type` is 1.
    --- @return ColorInstance
    --- @nodiscard
    getAmbientSkyColor = function() end,

    --- Sets the color of the gradient sky. Not used if `ambient_type` is 1.
    --- @param tint ColorLike
    --- @return boolean
    setAmbientSkyColor = function(tint) end,

    --- Returns color of the directional light, which shines down on the table.
    --- @return ColorInstance
    --- @nodiscard
    getLightColor = function() end,

    --- Sets the color of the directional light, which shines down on the table.
    --- @param tint ColorLike
    --- @return boolean
    setLightColor = function(tint) end,
}

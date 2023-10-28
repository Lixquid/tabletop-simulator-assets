--- @meta

--- @class ObjectInstanceGetObjectsContainersOutput
--- @field guid string GUID of the contained object.
--- @field name string Name of the contained object, as returned by `getName()`. If blank, it will be the internal resource name.

--- @class ObjectInstanceTakeObjectParameters
--- @field position VectorLike? The position to spawn the object at.
--- @field rotation VectorLike? The rotation to spawn the object at.
--- @field flip boolean? Whether to flip the object. Ignored if the container is not a card or `rotation` is set.
--- @field guid string? The GUID of the object to take. Only specify `guid` or `index`, not both.
--- @field index number? The index of the object to take. Only specify `guid` or `index`, not both.
--- @field top boolean? Whether to take objects from the top (`true`) or bottom (`false`) of the container.
--- @field smooth boolean? Whether to animate the object moving out of the container.
--- @field callback_function fun(object: ObjectInstance)? Called when the object has finished spawning.

--- @class ObjectInstanceSetCustomObjectCardParameters
--- @field type 0|1|2|3|4|nil The card shape.
--- @field face string The path/URL of the face image.
--- @field back string The path/URL of the back image.
--- @field sideways boolean? If the card is horizontal, instead of vertical.

--- @class ObjectInstanceSetCustomObjectTileParameters
--- @field image string The path/URL of the image.
--- @field type 0|1|2|nil The tile shape.
--- @field image_bottom string? The path/URL of the bottom image. If omitted, will use `image`.
--- @field thickness number? The thickness of the tile. Defaults to 0.5.
--- @field stackable boolean? Whether the tile is stackable. Defaults to `false`.

--- @class ObjectCreateButtonParameters
--- @field click_function string The name of the function to call when the button is clicked.
--- @field function_owner any The object that owns the function to call. If omitted, defaults to `Global`.
--- @field label string? The text to display on the button.
--- @field position VectorLike? The position of the button. Defaults to `{0, 0, 0}`.
--- @field rotation VectorLike? The rotation of the button. Defaults to `{0, 0, 0}`.
--- @field scale VectorLike? The scale of the button. Defaults to `{1, 1, 1}`.
--- @field width number? The width of the button. Defaults to `100`.
--- @field height number? The height of the button. Defaults to `100`.
--- @field font_size number? The font size of the button. Defaults to `100`.
--- @field color ColorLike? The color of the button. Defaults to white.
--- @field font_color ColorLike? The color of the button's text. Defaults to black.
--- @field hover_color ColorLike? The color of the button when hovered over.
--- @field press_color ColorLike? The color of the button when pressed.
--- @field tooltip string? The tooltip to display when hovered over.

--- Represents any entity in the game.
--- @class ObjectInstance
--- @field guid string The 6 character unique identifier for the object. Note that it is only set once the `spawning` member variable becomes false.
--- @field spawning boolean If the object has finished spawning.
local ObjectInstance = {
    --- Sets the color tint of the object.
    --- @param tint ColorLike
    setColorTint = function(tint) end,

    --- Sets the custom properties of the object.
    --- @param params ObjectInstanceSetCustomObjectCardParameters | ObjectInstanceSetCustomObjectTileParameters
    setCustomObject = function(params) end,

    --- Gets the name of the object, shown in the tooltip.
    --- @return string
    --- @nodiscard
    getName = function() end,

    --- Sets the name of the object, shown in the tooltip.
    --- @param name string
    setName = function(name) end,

    --- Returns data describing the objects contained within in the zone/bag/deck.
    --- @return ObjectInstanceGetObjectsContainersOutput[]
    --- @nodiscard
    getObjects = function() end,

    --- Creates a highlight around an object.
    --- @param color ColorLike
    --- @param duration number? The duration of the highlight in seconds. If omitted, the highlight will be permanent.
    highlightOn = function(color, duration) end,

    --- Removes a highlight around an object.
    --- @param color ColorLike? The highlight color to remove. If omitted, all highlights will be removed.
    highlightOff = function(color) end,

    --- Takes an object out of a container (bag/deck/chip stack), returning a
    --- reference to the object that was taken. Note that objects will not
    --- spawn immediately; set the `callback_function` parameter to be notified
    --- when the object has finished spawning.
    --- @param params ObjectInstanceTakeObjectParameters
    --- @return ObjectInstance
    takeObject = function(params) end,

    -- UI Functions ------------------------------------------------------------

    --- Creates a UI button attached to the object.
    --- @param params ObjectCreateButtonParameters
    createButton = function(params) end,
}

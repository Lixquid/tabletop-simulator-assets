--- @meta

--- @class PlayerInstance
--- @field blindfolded boolean If the player is blindfolded.
--- @field color PlayerColor The color of the player.
--- @field steam_id string The Steam ID of the player.
--- @field steam_name string The Steam name of the player.
--- @field team PlayerTeam The team of the player.
local PlayerInstance = {
    --- Changes the player to the specified color.
    --- @param color PlayerColor
    changeColor = function(color) end,

    --- Returns a table of objects that the player has selected with area selection.
    --- @return ObjectInstance[]
    --- @nodiscard
    getSelectedObjects = function() end,

    --- Prints a message into the Player's game chat.
    --- @param message string
    --- @param color ColorLike? The color of the message. If omitted, the message will be white.
    print = function(message, color) end,
}

--- @class Player
--- @field [PlayerColor] PlayerInstance? Gets the Player instance of the specified color.
Player = {
    --- Returns a table of all players.
    --- @return PlayerInstance[]
    --- @nodiscard
    getPlayers = function() end,
}

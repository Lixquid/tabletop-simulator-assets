--- @meta

-- Global Types ----------------------------------------------------------------

--- @alias PlayerColor "White"| "Brown"| "Red"| "Orange"| "Yellow"| "Green"| "Teal"| "Blue"| "Purple"| "Pink"| "Grey"| "Black"
--- @alias PlayerTeam "None"| "Clubs"| "Diamonds"| "Hearts"| "Spades"| "Jokers"

--- @type unknown
Global = nil

--- @type ObjectInstance
self = nil

-- Global Functions ------------------------------------------------------------

--- Destroys an Object.
--- @param object ObjectInstance The object to destroy.
function destroyObject(object) end

--- Returns a list of all Objects in the game *except hand zones*.
--- @return ObjectInstance[]
--- @nodiscard
--- @deprecated Use `getObjects()` instead.
function getAllObjects() end

--- Returns an Object with the given GUID. Returns `nil` if not found.
--- @param guid string The GUID of the Object to get.
--- @return ObjectInstance?
--- @nodiscard
function getObjectFromGUID(guid) end

--- Returns a list of all Objects in the game.
--- @return ObjectInstance[]
--- @nodiscard
function getObjects() end

--- Returns a list of all Player Colors of seated players.
--- @return PlayerColor[]
--- @nodiscard
function getSeatedPlayers() end

--- Parameters for the `spawnObject()` function.
--- @class SpawnObjectParameters
--- @field type string The type of object to spawn.
--- @field position Vector? Position of the spawned object.
--- @field rotation Vector? Rotation of the spawned object.
--- @field scale Vector? Scale of the spawned object.
--- @field sound boolean? Whether a sound will be played as the object spawns.
--- @field snap_to_grid boolean? Whether upon spawning, the object will snap to nearby grid lines (or snap points).
--- @field callback_function fun(object: ObjectInstance)? Called when the object has finished spawning.

--- Spawns a new object.
--- @param params SpawnObjectParameters The parameters to spawn the object with.
--- @return ObjectInstance
function spawnObject(params) end

-- Message Functions -----------------------------------------------------------

--- Print an on-screen message to all Players.
--- @param message string The message to print.
--- @param tint ColorLike? The color of the message. If omitted, the message will be white.
function broadcastToAll(message, tint) end

--- Print an on-screen message to a specified Player.
--- @param message string The message to print.
--- @param player_color PlayerColor The color of the player to print to.
--- @param tint ColorLike? The color of the message. If omitted, the message will be white.
function broadcastToColor(message, player_color, tint) end

-- TODO: Add logStyle parameter

--- Logs a message to the *host*'s System Console (accessible via the `~` key).
--- @param value any The value to log.
--- @param label string? Text to log before the value.
function log(value, label) end

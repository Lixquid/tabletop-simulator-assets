--- @meta

--- Sets the information about the game/mod, in the same way as the in-game
--- Options > Info menu. This information is used to help find / classify your
--- game within the server list and via the Workshop.
Info = {
    --- The complexity of the game/mod.
    --- @type string?
    complexity = nil,

    --- The name of the game/mod.
    --- @type string?
    name = nil,

    --- The minimum and maximum number of players for the game/mod.
    --- @type {[1]: number, [2]: number}?
    number_of_players = nil,

    --- The minimum and maximum estimated playtime for the game/mod.
    --- @type {[1]: number, [2]: number}?
    playing_time = nil,

    --- The tags associated with the game/mod.
    --- @type string[]?
    tags = nil,

    --- The category of the game/mod.
    --- @type string?
    type = nil,
}

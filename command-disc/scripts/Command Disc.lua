--[[
-- Command Disc
-- Script, Art Assets by Lixquid
--]]

--- @alias FnArgs {[number]: string, raw: string, player: PlayerInstance}

-- Util ------------------------------------------------------------------------

--- Splits a string into a table of strings, using the given pattern.
--- @param str string The string to split.
--- @param pattern string The Lua pattern to split on.
--- @return string[]
local function splitString(str, pattern)
    local t = {}
    for s in string.gmatch(str, pattern) do
        table.insert(t, s)
    end
    return t
end
--- Returns a new table with the results of calling the given function on every
--- element in the given table.
--- @generic TKey, TValue, TReturn
--- @param tbl table<TKey, TValue> The table to map.
--- @param fn fun(value: TValue, key: TKey): TReturn The function to call on each element.
--- @return table<TKey, TReturn>
local function map(tbl, fn)
    local out = {}
    for k, v in next, tbl do
        out[k] = fn(v, k)
    end
    return out
end
--- Returns a new table with the elements from the given table that pass the
--- given function. The element is included if the function returns anything
--- other than false or nil.
--- @generic TKey, TValue
--- @param tbl table<TKey, TValue> The table to filter.
--- @param fn fun(value: TValue, key: TKey): any The function to call on each element.
--- @return table<TKey, TValue>
local function filter(tbl, fn)
    local out = {}
    for k, v in next, tbl do
        if fn(v, k) then out[k] = v end
    end
    return out
end
--- A map of player colors to their chat formatting tags.
--- @type table<PlayerColor, string>
local playerColors = {
    White = "[ffffff]",
    Brown = "[703a16]",
    Red = "[da1917]",
    Orange = "[f3631c]",
    Yellow = "[e6e42b]",
    Green = "[30b22a]",
    Teal = "[20b09a]",
    Blue = "[1e87ff]",
    Purple = "[9f1fef]",
    Pink = "[f46fcd]",
    Grey = "[7f7f7f]",
    Black = "[3f3f3f]"
}
--- A set of player teams.
--- @type table<PlayerTeam, PlayerTeam>
local playerTeams = {
    None = "None",
    Clubs = "Clubs",
    Diamonds = "Diamonds",
    Hearts = "Hearts",
    Spades = "Spades",
    Jokers = "Jokers"
}
--- Returns the chat-formatted string for the given player.
--- @param player PlayerInstance
--- @return string
local function playerStr(player)
    return playerColors[player.color] .. (player.steam_name or player.color) .. "[-]"
end
--- Returns a table of players depending on the search string.
--- @param str string The search string.
--- @param ply PlayerInstance The player that invoked the command.
--- @return PlayerInstance[]
local function getTargets(str, ply)
    if not str then
        return {}
    end
    if str == "*" then
        -- Everyone seated
        return map(getSeatedPlayers(), function(p) return Player[p] end)
    end
    if str == "*!" then
        -- Everyone in the game
        return Player.getPlayers()
    end
    if str == "^" then
        -- Yourself
        return { ply }
    end
    if playerColors[str] then
        -- A player colour
        return { Player[str] }
    end
    if playerTeams[str] then
        -- A team
        return filter(Player.getPlayers(), function(p) return p.team == str end)
    end
    for _, v in next, Player.getPlayers() do
        -- SteamID
        if string.lower(v.steam_id) == string.lower(str) then
            return { v }
        end
    end
    local out = filter(Player.getPlayers(), function(p)
        -- Exact Name match
        return string.lower(p.steam_name) == string.lower(str)
    end)
    if #out > 0 then return out end

    return filter(Player.getPlayers(), function(p)
        -- Fuzzy name match
        return string.find(string.lower(p.steam_name), string.lower(str))
    end)
end
local CM = "[2C72C7]" .. string.char(9654) .. "[-] "

-- Commands --------------------------------------------------------------------

--- The main commands table format:
-- fn: function, Required
--     The function run when the command is invoked. It's passed a single table,
--     which contains the arguments in the numeric keys, the raw string under
--     the "raw" key, and the player that invoked the command under the "player"
--     key.
-- description: string, Optional
--     A human friendly description of the command, shown in help.
-- usage: string, Optional
--     Extra parameter information shown after a command in help.
--     For example: "add <player> [id]"
-- admin: boolean, Optional
--     If true, only promoted players or the host can run this command.
--- @type table<string, {fn: fun(args: FnArgs), description: string?, usage: string?, admin: boolean?}>
local commands = {}

commands.help = {
    name = "help",
    description = "Displays all available commands and their usage.",
    fn = function(args)
        local s = { "\n", CM, "[b][6193CF]Command Disc Commands[-][/b]\n" }
        for name, c in next, commands do
            if c.admin then table.insert(s, "[E85752]" .. string.char(9733) .. "[-]") end
            table.insert(s, "[F29B68]!" .. name .. "[-]")
            if c.usage then
                table.insert(s, " [FCD9B0]" .. c.usage .. "[-]")
            end
            if c.description then
                table.insert(s, "\n[i]    " .. string.gsub(c.description, "\n", "\n    ") .. "[/i]")
            end
            table.insert(s, "\n")
        end
        args.player.print(table.concat(s))
    end
}

commands.random = {
    description = [[
<max>: Displays a random number between 1 and max.
[num]d<max>: Rolls <num> dice with a maximum of <max>. e.g. !random 3d20
player: Outputs a random seated player from those present.
player!: Outputs a random player from everyone in the game, including spectators.]],
    usage = "<max>|[num]d<max>|player|player!",
    fn = function(args)
        if not args[1] then
            args.player.print(CM .. "[E85752]No format argument specified. Run !help for help on this command![-]\n")
            return
        end

        if args[1] == "player" then
            local players = getSeatedPlayers()
            local randomPlayer = players[math.random(#players)]
            broadcastToAll(CM .. "Random Player: " .. playerColors[randomPlayer] .. randomPlayer .. "[-]")
            return
        end
        if args[1] == "player!" then
            local players = Player.getPlayers()
            broadcastToAll(CM .. "Random Player: " .. playerStr(players[math.random(#players)]))
            return
        end

        local dNum, dMax = string.match(args[1], "^(%d*)d(%d+)$")
        if not dMax then
            dMax = tonumber(args[1])
        end
        if dMax then
            dNum = tonumber(dNum) or 1
            dMax = tonumber(dMax)
            local rolls = {}
            local sum = 0
            for i = 1, dNum do
                table.insert(rolls, math.random(dMax --[[@as number]]))
                sum = sum + rolls[#rolls]
            end
            broadcastToAll(CM ..
                playerStr(args.player) .. " rolled [A4C0E4]" .. dNum .. "d" .. dMax .. "[-]: [F2BB88]" ..
                (#rolls > 1 and table.concat(rolls, ", ") .. " = " or "") ..
                sum .. "[-]"
            )
            return
        end

        args.player.print(CM .. "[E85752]Unknown format argument. Run !help for help on this command![-]\n")
    end
}

commands.count = {
    description = "Counts how many objects you have selected.",
    fn = function(args)
        args.player.print(CM .. "You've selected " .. #args.player.getSelectedObjects() .. " object(s).")
    end
}

commands.highlight = {
    description = "Creates or removes a highlight around objects you have selected. e.g. !highlight ff00ff",
    usage = "<color_string>|off",
    fn = function(args)
        local o = args.player.getSelectedObjects()

        if #o == 0 then
            args.player.print(CM .. "[E85752]You have no selected objects. Run !help for help on this command![-]\n")
            return
        end

        if args[1] == "off" then
            for _, v in next, o do
                v.highlightOff()
            end
            return
        end

        local cr, cg, cb = string.match(args[1], "^(%x%x)(%x%x)(%x%x)$")
        if cr then
            local c = { tonumber(cr, 16), tonumber(cg, 16), tonumber(cb, 16) }
            for _, v in next, o do
                v.highlightOn(c)
            end
            return
        end

        args.player.print(CM .. "[E85752]Unknown format argument. Run !help for help on this command![-]\n")
    end
}

commands.blind = {
    description = "Blindfolds targeted players.",
    usage = "<targets>",
    admin = true,
    fn = function(args)
        local targets = getTargets(args[1], args.player)
        if #targets == 0 then
            args.player.print(CM .. "[E85752]No targets found. Run !help for help on this command![-]\n")
            return
        end

        for _, v in next, targets do
            v.blindfolded = true
        end
        broadcastToAll(CM .. playerStr(args.player) .. " has blinded " .. (
            args[1] == "*" and "everyone seated" or
            args[1] == "*!" and "everyone" or
            #targets == 1 and targets[1] == args.player and "themselves" or
            table.concat(map(targets, function(p) return p.color end), ", ")
        ) .. ".")
    end
}

commands.unblind = {
    description = "Removes blindfolds from targeted players.",
    usage = "<targets>",
    admin = true,
    fn = function(args)
        local targets = getTargets(args[1], args.player)
        if #targets == 0 then
            args.player.print(CM .. "[E85752]No targets found. Run !help for help on this command![-]\n")
            return
        end

        for _, v in next, targets do
            v.blindfolded = false
        end
        broadcastToAll(CM .. playerStr(args.player) .. " has un-blinded " .. (
            args[1] == "*" and "everyone seated" or
            args[1] == "*!" and "everyone" or
            #targets == 1 and targets[1] == args.player and "themselves" or
            table.concat(map(targets, function(p) return p.color end), ", ")
        ) .. ".")
    end
}

commands.changecolor = {
    description = "Forces another player to change color.",
    usage = "<target> <color>",
    admin = true,
    fn = function(args)
        local targets = getTargets(args[1], args.player)
        if #targets == 0 then
            args.player.print(CM .. "[E85752]No targets found. Run !help for help on this command![-]\n")
            return
        end
        if #targets > 1 then
            args.player.print(CM .. "[E85752]Multiple targets found. Run !help for help on this command![-]\n")
            return
        end

        if not playerColors[args[2]] then
            args.player.print(CM ..
                "[E85752]" ..
                tostring(args[2]) ..
                " is not a valid color. Valid colors: White, Brown, Red, Orange, Yellow, Green, Teal, Blue, Purple, Pink, Grey, Black[-]\n")
            return
        end

        targets[1].changeColor(args[2])
        broadcastToAll(CM ..
            playerStr(args.player) ..
            " changed " .. playerStr(targets[1]) .. "'s color to " .. playerColors[args[2]] .. args[2] .. "[-].")
    end
}

commands.changeteam = {
    description = "Forces players to change team.",
    usage = "<targets> None|Clubs|Diamonds|Hearts|Spades|Jokers",
    admin = true,
    fn = function(args)
        local targets = getTargets(args[1], args.player)
        if #targets == 0 then
            args.player.print(CM .. "[E85752]No targets found. Run !help for help on this command![-]\n")
            return
        end

        if not playerTeams[args[2]] then
            args.player.print(CM ..
                "[E85752]" ..
                tostring(args[2]) ..
                " is not a valid team. Valid teams: None, Clubs, Diamonds, Hearts, Spades, Jokers[-]\n")
        end

        targets[1].team = args[2]
        broadcastToAll(CM ..
            playerStr(args.player) .. " changed " .. playerStr(targets[1]) .. "'s team to " .. args[2] .. ".")
    end
}

local lighting_cache = {}
commands.lighting = {
    description = "Saves / Loads saved lighting modes. e.g. !lighting save 1, !lighting load 1",
    usage = "save|s|load|l <id>, list|clear",
    admin = true,
    fn = function(args)
        if args[1] == "load" or args[1] == "l" then
            if not lighting_cache[args[2]] then
                args.player.print(CM ..
                    "[E85752]No lighting mode exists with that name. Run !help for help on this command![-]\n")
                return
            end
            local m = lighting_cache[args[2]]
            Lighting.ambient_type = m.at
            Lighting.ambient_intensity = m.ai
            Lighting.light_intensity = m.li
            Lighting.reflection_intensity = m.ri
            Lighting.setAmbientEquatorColor(m.ae)
            Lighting.setAmbientGroundColor(m.ag)
            Lighting.setAmbientSkyColor(m.as)
            Lighting.setLightColor(m.lc)
            Lighting.apply()
            args.player.print(CM .. "Loaded lighting mode " .. args[2] .. ".")
            return
        elseif args[1] == "save" or args[1] == "s" then
            if not args[2] then
                args.player.print(CM .. "[E85752]No mode name specified. Run !help for help on this command![-]\n")
                return
            end
            lighting_cache[args[2]] = {
                at = Lighting.ambient_type,
                ai = Lighting.ambient_intensity,
                li = Lighting.reflection_intensity,
                ri = Lighting.reflection_intensity,
                ae = Lighting.getAmbientEquatorColor(),
                ag = Lighting.getAmbientGroundColor(),
                as = Lighting.getAmbientSkyColor(),
                lc = Lighting.getLightColor()
            }
            args.player.print(CM .. "Saving lighting mode " .. args[2] .. ".")
            return
        elseif args[1] == "list" then
            local keys = {}
            for k in next, lighting_cache do table.insert(keys, k) end
            args.player.print(CM .. "Lighting modes: " .. table.concat(keys, ", "))
            return
        elseif args[1] == "clear" then
            lighting_cache = {}
            args.player.print(CM .. "Lighting modes cleared.")
            return
        end

        args.player.print(CM .. "[E85752]Save or load must be specified. Run !help for help on this command![-]\n")
    end
}

-- Lifecycle -------------------------------------------------------------------

function onChat(raw, player)
    if string.sub(raw, 1, 1) ~= "!" then return end
    --- @type FnArgs
    local args = splitString(raw, "%S+")
    local commandName = string.sub(args[1], 2)
    table.remove(args, 1)
    args.player = player
    args.raw = raw

    local command = commands[commandName]
    if not command then
        player.print(CM .. "[E85752]Command " .. commandName .. " not found![-]\n")
        commands.help.fn(args)
        return
    end
    if command.admin and not player.admin then
        player.print(CM .. "[E85752]You must be an admin to run that command![-]\n")
        return
    end
    command.fn(args)
end

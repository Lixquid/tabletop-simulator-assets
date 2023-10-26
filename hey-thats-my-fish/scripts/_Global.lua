--[[----------------------------------------------------------------------------
-- Hey, That's My Fish! - Scripted Edition
-- Script, Art Assets by Lixquid
-- Manual, Game Design by Fantasy Flight Games
-- Background by https://pxhere.com/en/photo/895374, licensed under CC0 Public Domain
-- Penguin model by https://sketchfab.com/3d-models/penguin-f65e799bf9534c66a12724a93bb72c39, licensed under CC Attribution - NoDerivs
--]]----------------------------------------------------------------------------

-- Objects ---------------------------------------------------------------------

local BAG_RED
local BAG_YELLOW
local BAG_GREEN
local BAG_BLUE
local COUNTER_RED
local COUNTER_YELLOW
local COUNTER_GREEN
local COUNTER_BLUE

-- Tiles -----------------------------------------------------------------------

local tileImages = {
    "https://glcdn.githack.com/Lixquid/tabletop-simulator-assets/raw/ab74b56f88a2f7052941334b57e7224cad74d9c3/hey-thats-my-fish/one.png",
    "https://glcdn.githack.com/Lixquid/tabletop-simulator-assets/raw/ab74b56f88a2f7052941334b57e7224cad74d9c3/hey-thats-my-fish/two.png",
    "https://glcdn.githack.com/Lixquid/tabletop-simulator-assets/raw/ab74b56f88a2f7052941334b57e7224cad74d9c3/hey-thats-my-fish/three.png",
}
local function spawnTile(pos, num)
    local o = spawnObject({
        type = "Custom_Tile",
        position = pos,
        rotation = {0, 90, 0},
        snap_to_grid = true,
        sound = false
    })
    o.setCustomObject({
        image = tileImages[num],
        image_bottom = "https://glcdn.githack.com/Lixquid/tabletop-simulator-assets/raw/ab74b56f88a2f7052941334b57e7224cad74d9c3/hey-thats-my-fish/sea.png",
        type = 1 -- Hex
    })
    o.setColorTint({0x22 / 0xff, 0x66 / 0xff, 0xcc / 0xff})
    o.setName(num .. " fish")
end

local function getTileLayout()
    local tiles = {}
    for i = 1, 30 do
        table.insert(tiles, 1)
        if i <= 20 then table.insert(tiles, 2) end
        if i <= 10 then table.insert(tiles, 3) end
    end
    for i = 60, 1, -1 do
        local j = math.random(i)
        tiles[i], tiles[j] = tiles[j], tiles[i]
    end
    return tiles
end

local TILE_OFFSET_X = -5.72
local TILE_OFFSET_Z = 5.5
local TILE_DELTA_X = 1.91
local TILE_DELTA_Z = -1.65

function buildTiles()
    -- Cleanup
    for _, o in next, getAllObjects() do
        local name = o.getName()
        if name == "1 fish" or name == "2 fish" or name == "3 fish" then
            destroyObject(o)
        end
    end
    local function emptyBag(bag)
        if not bag then return end
        for _, v in next, bag.getObjects() do
            bag.takeObject({
                position = {0, -5, 0},
                smooth = false,
                guid = v.guid,
                callback_function = destroyObject
            })
        end
    end
    emptyBag(BAG_RED)
    emptyBag(BAG_YELLOW)
    emptyBag(BAG_GREEN)
    emptyBag(BAG_BLUE)

    -- Build
    local tiles = getTileLayout()
    local i = 1
    for y = 0, 7 do
        for x = 0, 7 do
            if x < 7 or y % 2 == 1 then
                spawnTile({
                    TILE_OFFSET_X + x * TILE_DELTA_X - y % 2 * TILE_DELTA_X / 2,
                    1,
                    TILE_OFFSET_Z + y * TILE_DELTA_Z
                }, tiles[i])
                i = i + 1
            end
        end
    end
end

-- Scores ----------------------------------------------------------------------

local function calculateScores()
    local function calc(bag, counter)
        if not bag or not counter then return end
        local score = 0
        for _, tile in next, bag.getObjects() do
            local name = tile.name
            if name == "1 fish" then score = score + 1
            elseif name == "2 fish" then score = score + 2
            elseif name == "3 fish" then score = score + 3
            end
        end
        counter.Counter.setValue(score)
    end
    calc(BAG_RED, COUNTER_RED)
    calc(BAG_YELLOW, COUNTER_YELLOW)
    calc(BAG_GREEN, COUNTER_GREEN)
    calc(BAG_BLUE, COUNTER_BLUE)
end

-- Lifecycle -------------------------------------------------------------------

function onLoad()
    BAG_RED = getObjectFromGUID("aaa482")
    BAG_YELLOW = getObjectFromGUID("48e68f")
    BAG_GREEN = getObjectFromGUID("81096a")
    BAG_BLUE = getObjectFromGUID("95b911")
    COUNTER_RED = getObjectFromGUID("1cf178")
    COUNTER_YELLOW = getObjectFromGUID("6eae90")
    COUNTER_GREEN = getObjectFromGUID("46d089")
    COUNTER_BLUE = getObjectFromGUID("5e84db")
    buildTiles()
end
function onObjectEnterContainer()
    calculateScores()
end
function onObjectLeaveContainer()
    calculateScores()
end
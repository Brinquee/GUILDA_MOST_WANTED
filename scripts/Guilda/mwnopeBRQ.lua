setDefaultTab("guild")

local mw = macro(100, "MW NO SEU PE", "F10", function() end)

onPlayerPositionChange(function(newPos, oldPos)
    if not oldPos or oldPos.z ~= posz() then return end
    
    local tile = g_map.getTile(oldPos)
    if mw.isOn() and tile and tile:isWalkable() then
        -- Alterado de 3188 (Fire) para 3180 (Magic Wall)
        useWith(3180, tile:getTopUseThing())
    end
end)

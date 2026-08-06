setDefaultTab("guild")

local mw = macro(100, "MW NO SEU PE", "F10",function() end)
onPlayerPositionChange(function(newPos, oldPos)
    if oldPos.z ~= posz() then return end
    if oldPos then
        local tile = g_map.getTile(oldPos)
        if mw.isOn() and tile:isWalkable() then
            useWith(3180, tile:getTopUseThing())
        end
    end
end)

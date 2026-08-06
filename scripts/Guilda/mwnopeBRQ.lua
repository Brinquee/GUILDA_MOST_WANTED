setDefaultTab("guild")

-- Força o VBot a atualizar o ID correto da MW e não ler o cache antigo
local MWALL_ID = 3180 

local mw = macro(100, "MW NO SEU PE", "F10", function() end)

onPlayerPositionChange(function(newPos, oldPos)
    if not oldPos or oldPos.z ~= posz() then return end
    
    local tile = g_map.getTile(oldPos)
    if mw.isOn() and tile and tile:isWalkable() then
        -- Usa o ID estrito definido acima (3180)
        useWith(MWALL_ID, tile:getTopUseThing())
    end
end)

-- Caixa visual para você ver e testar o ID que o Bot está puxando
UI.Label("ID da Mwall:")
UI.TextEdit(tostring(MWALL_ID), function(widget, newText)
    local newId = tonumber(newText)
    if newId then MWALL_ID = newId end
end)

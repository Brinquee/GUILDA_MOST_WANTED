hotkey("f1", "Drop item to Mouse", function()
    local tile = getTileUnderCursor()
    if tile then
        local pos = tile:getPosition()
        local itemToMouse = 3031
        for _, container in pairs(g_game.getContainers()) do
            for __, item in ipairs(container:getItems()) do
                if item:getId() == itemToMouse then
                    return g_game.move(item, pos, 1)
                end
            end
        end
    end
end)

hotkey("1", "Drop item to Mouse", function()
        local neighbours = {
            { x = 0, y = -1, z = 0 },
            { x = -1, y = -1, z = 0 },
            { x = -1, y = 0, z = 0 },
            { x = -1, y = 1, z = 0 },
            { x = 0, y = 1, z = 0 },
            { x = 1, y = 1, z = 0 },
            { x = 1, y = 0, z = 0 },
            { x = 1, y = -1, z = 0 }
        }
    local tile = getTileUnderCursor()
    if tile then
        local pos = tile:getPosition()
        local itemToMouse = 3031
        for _, container in pairs(g_game.getContainers()) do
            for __, item in ipairs(container:getItems()) do
                if item:getId() == itemToMouse then
                    for k, v in pairs(neighbours) do
                        local posN = { x = pos.x + v.x, y = pos.y + v.y, z = pos.z + v.z }
                        g_game.move(item, posN, 1)
                    end
                    return
                end

            end
        end
    end
end)
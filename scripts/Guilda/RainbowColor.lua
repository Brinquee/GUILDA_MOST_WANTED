macro(500, "Rainbow Uma Cor", function()
    local currentOutfit = player:getOutfit()
    
    -- Escolhe uma única cor aleatória para a roupa toda
    local corUnica = math.random(1, 132)
    
    local outfit = {
        type = currentOutfit.type,
        head = corUnica,
        body = corUnica,
        legs = corUnica,
        feet = corUnica,
        addons = currentOutfit.addons,
        mount = currentOutfit.mount
    }
    
    if setOutfit then
        setOutfit(outfit)
    else
        g_game.changeOutfit(outfit)
    end
end)
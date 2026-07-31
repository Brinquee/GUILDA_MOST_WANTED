macro(1000, "openbagmainBRQ", function()
    bpItem = getBack()
    bp = getContainer(0)

    if not bp and bpItem ~= nil then
        g_game.open(bpItem)
    end

end)

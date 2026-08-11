
setDefaultTab("main")


panel = mainTab;

local bugMap = {};

-- CRIAÇÃO DA SUA CAIXA DE MARCAR ORIGINAL NA ABA MAIN
bugMap.checkBox = setupUI([[
CheckBox
  id: checkBox
  font: cipsoftFont
  text: Use Diagonal
]]);

bugMap.checkBox.onCheckChange = function(widget, checked)
    storage.bugMapCheck = checked;
end

if storage.bugMapCheck == nil then
  storage.bugMapCheck = true;
end

bugMap.checkBox:setChecked(storage.bugMapCheck);

bugMap.isKeyPressed = modules.corelib.g_keyboard.isKeyPressed;

bugMap.directions = {
    ["W"] = {x = 0, y = -5, direction = 0},
    ["E"] = {x = 3, y = -3},
    ["D"] = {x = 5, y = 0, direction = 1},
    ["C"] = {x = 3, y = 3},
    ["S"] = {x = 0, y = 5, direction = 2},
    ["Z"] = {x = -3, y = 3},
    ["A"] = {x = -5, y = 0, direction = 3},
    ["Q"] = {x = -3, y = 3}
};

-- O SEU MACRO ORIGINAL (VAI SER CONTROLADO PELO ÍCONE FLUTUANTE)
bugMap.macro = macro(1, "Bug Map", function()
    if (modules.game_console:isChatEnabled() or modules.corelib.g_keyboard.isCtrlPressed()) then return; end
    local pos = pos();
    for key, config in pairs(bugMap.directions) do
        if (bugMap.isKeyPressed(key)) then
            if (storage.bugMapCheck or config.direction) then
                if (config.direction) then
                    turn(config.direction);
                end
                local tile = g_map.getTile({x = pos.x + config.x, y = pos.y + config.y, z = pos.z});
                if (tile) then
                    return g_game.use(tile:getTopUseThing());
                end
            end
        end
    end
end)
-- INJEÇÃO DO ÍCONE FLUTUANTE BASEADO NO SEU MODELO DO BRINQUE (ID DO ITEM 3231)
local iconeBugMap = addIcon("BugMapIcon", {item = 3231, text = "BugMap"}, bugMap.macro)
iconeBugMap:breakAnchors();

-- Modifique as coordenadas abaixo (300, 290) para arrastar o ícone para onde quiser no monitor!
iconeBugMap:move(300, 290);

print(">>> [BUGMAP] Seu motor original foi restaurado e o Icone Flutuante foi injetado com sucesso!")

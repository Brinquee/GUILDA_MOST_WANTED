setDefaultTab("Cave")

-- Inicialização segura do contador dentro do storage nativo do vBot
if not storage.caveCounterIndex then
  storage.caveCounterIndex = 1
end

g_ui.loadUIFromString([[
CaveBotControlPanel < Panel
  margin-top: 5
  layout:
    type: verticalBox
    fit-children: true

  HorizontalSeparator
  
  Label
    text-align: center
    text: Gerador Multi-Caves
    font: verdana-11px-rounded
    margin-top: 3

  HorizontalSeparator
    
  Panel
    id: buttons
    margin-top: 2
    layout:
      type: grid
      cell-size: 86 20
      cell-spacing: 1
      flow: true
      fit-children: true

  HorizontalSeparator
    margin-top: 3
]])

local panel = UI.createWidget("CaveBotControlPanel")

-- [[ GERADOR MULTI-CAVES ]] --

-- 1. BOTÃO DA ENTRADA DA CAVE
local btnAddEntrada = UI.Button("Add Entrada", function(widget)
    local localPlayer = g_game.getLocalPlayer()
    if not localPlayer then return end

    local myPos = localPlayer:getPosition()
    local numeroAtual = storage.caveCounterIndex or 1
    local labelAtual = "end" .. numeroAtual
    
    -- Estrutura limpa de checagem e caminhada
    local textoFunction = string.format([[
local labelFuga = "%s"
local myPos = player:getPosition()
local spectators = g_map.getSpectators(myPos)
for _, c in ipairs(spectators) do
    if c:isPlayer() and c:getId() ~= player:getId() then
        CaveBot.gotoLabel(labelFuga)
        return true
    end
end
autoWalk({x=%d, y=%d, z=%d})
delay(1200)
return true]], labelAtual, myPos.x, myPos.y, myPos.z)

    if CaveBot and CaveBot.addAction then
        CaveBot.addAction("function", textoFunction)
        print("[Gerador] Entrada adicionada! Alvo de fuga: " .. labelAtual)
    end
end, panel.buttons)

-- 2. BOTÃO DA ROTA DE FUGA (Nome alterado para FugaLabel)
local btnAddFuga = UI.Button("FugaLabel", function(widget)
    local numeroAtual = storage.caveCounterIndex or 1
    local labelAtual = "end" .. numeroAtual
    
    if CaveBot and CaveBot.addAction then
        CaveBot.addAction("label", labelAtual)
        
        -- Atualiza e salva o contador no storage
        storage.caveCounterIndex = numeroAtual + 1
        print("[Gerador] Label " .. labelAtual .. " inserido! Próximo: end" .. storage.caveCounterIndex)
    end
end, panel.buttons)

-- 3. BOTÃO DE RESET DO CONTADOR
local btnResetContador = UI.Button("Reset Ends", function(widget)
    storage.caveCounterIndex = 1
    print("[Gerador] Contador reiniciado para end1!")
end, panel.buttons)

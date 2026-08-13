local widgetRaizDoJogo = g_ui.getRootWidget()

setDefaultTab("guild")

if not storage.mwallPainelConfig then
    storage.mwallPainelConfig = {}
end

local config = storage.mwallPainelConfig

-- BLINDAGEM DE STORAGE: Variáveis rebatizadas para nunca mais colidirem com o Exiva ou outros macros
if config.mwMacroPeAtivo == nil then config.mwMacroPeAtivo = false end
if config.mwAutoTargetAtivo == nil then config.mwAutoTargetAtivo = false end
if config.modoCerco == nil then config.modoCerco = 0 end
if not config.hotkeyMwall then config.hotkeyMwall = "F10" end
if not config.runeIdMwall then config.runeIdMwall = 3180 end
if not config.hotkeyTargetMw then config.hotkeyTargetMw = "F5" end
if not config.squaresThreshold then config.squaresThreshold = 2 end
if not config.delayTargetMw then config.delayTargetMw = 100 end

local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaMwallPainel\n" ..
"  size: 280 540\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblSecaoUm\n" ..
"    text: == MW NO SEU PE ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarHotkey\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarRuneId\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  BotSwitch\n" ..
"    id: swLigaMacroInterno\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"  Label\n" ..
"    id: lblSecaoDois\n" ..
"    text: == MW FRENTE TARGET ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarHotkeyTarget\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarDistancia\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarDelayTarget\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  BotSwitch\n" ..
"    id: swLigaAutoTarget\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"  BotSwitch\n" ..
"    id: swLigaCercarAlvo\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 22\n" ..
"  Label\n" ..
"    id: lblMarcaDaguaUniversal\n" ..
"    text: >> BRINQUE MACROS <<\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.horizontalCenter: parent.horizontalCenter\n" ..
"    margin-bottom: 40\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 22\n"

local designPopUpOTUI = "MainWindow\n" ..
"  id: janelaMwallPop\n" ..
"  !text: tr('Editar Campo')\n" ..
"  size: 260 130\n" ..
"  anchors.centerIn: parent\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblInfo\n" ..
"    text: Digite o novo valor:\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"  TextEdit\n" ..
"    id: txtEntrada\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"  Button\n" ..
"    id: btnConfirmar\n" ..
"    text: CONFIRMAR\n" ..
"    color: green\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-right: 4\n" ..
"  Button\n" ..
"    id: btnCancelar\n" ..
"    text: Cancelar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 4\n"

local principalWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
local mwallPopWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
principalWindow:hide()
mwallPopWindow:hide()

local painelDaAbaGuild = getTab("guild")
if painelDaAbaGuild:recursiveGetChildById("panelBotoesMwallNativos") then
    painelDaAbaGuild:recursiveGetChildById("panelBotoesMwallNativos"):destroy()
end

local botoesLateraisUI = setupUI([[
Panel
  id: panelBotoesMwallNativos
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4

  BotSwitch
    id: btnLigaMacro
    width: 85

  Button
    id: btnAbrePainel
    text: Setup MW
    width: 85
]], painelDaAbaGuild)

local campoModeloEditandoVal = ""
local ultimoDisparoMw = 0

local function tacarMwNaPos(pos)
    local tile = g_map.getTile(pos)
    if tile then useWith(config.runeIdMwall or 3180, tile:getTopUseThing()) end
end
-- =============================================================================
-- [BLOCO 3] LISTENERS DE KEYPRESS E MOTORES DE COMBATE MWALL (RAM ISOLADA)
-- =============================================================================

onKeyPress(function(keys)
    if modules.game_console:isChatEnabled() then return end
    
    if config.hotkeyMwall and keys:lower() == config.hotkeyMwall:lower() then
        config.mwMacroPeAtivo = not config.mwMacroPeAtivo
        atualizarTextoDosBotoesPainel()
    end
    
    if config.hotkeyTargetMw and keys:lower() == config.hotkeyTargetMw:lower() then
        config.mwAutoTargetAtivo = not config.mwAutoTargetAtivo
        atualizarTextoDosBotoesPainel()
    end
end)

-- MOTOR DE METRALHAR MW NO TARGET (20ms)
macro(20, function()
    if modules.game_console:isChatEnabled() then return end
    
    local deveAtacar = config.mwAutoTargetAtivo
    if config.hotkeyTargetMw and g_keyboard.isKeyPressed(config.hotkeyTargetMw) then
        deveAtacar = true
    end
    
    if deveAtacar then
        local agora = os.clock() * 1000
        local delayConfigurado = config.delayTargetMw or 100
        
        if agora - ultimoDisparoMw >= delayConfigurado then
            local target = g_game.getAttackingCreature()
            if target then
                local targetPos = target:getPosition()
                local targetDir = target:getDirection()
                local threshold = config.squaresThreshold or 2
                
                -- MODO 2: Cerco Total (Tranca os 8 SQMs ao redor do inimigo)
                if config.modoCerco == 2 then
                    local direcoes8 = {
                        {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1},
                        {x=-1, y=0},               {x=1, y=0},
                        {x=-1, y=1},  {x=0, y=1},  {x=1, y=1}
                    }
                    for _, offset in ipairs(direcoes8) do
                        local posAlvoBox = {x = targetPos.x + offset.x, y = targetPos.y + offset.y, z = targetPos.z}
                        tacarMwNaPos(posAlvoBox)
                    end
                else
                    -- MODOS 0 e 1: Calculo por direcao do olhar do alvo
                    local posCentro = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                    local posLadoA = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                    local posLadoB = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
                    
                    if targetDir == 0 then -- North
                        posCentro.y = posCentro.y - threshold
                        posLadoA.x, posLadoA.y = posLadoA.x - 1, posLadoA.y - threshold
                        posLadoB.x, posLadoB.y = posLadoB.x + 1, posLadoB.y - threshold
                    elseif targetDir == 1 then -- East
                        posCentro.x = posCentro.x + threshold
                        posLadoA.x, posLadoA.y = posLadoA.x + threshold, posLadoA.y - 1
                        posLadoB.x, posLadoB.y = posLadoB.x + threshold, posLadoB.y + 1
                    elseif targetDir == 2 then -- South
                        posCentro.y = posCentro.y + threshold
                        posLadoA.x, posLadoA.y = posLadoA.x - 1, posLadoA.y + threshold
                        posLadoB.x, posLadoB.y = posLadoB.x + 1, posLadoB.y + threshold
                    elseif targetDir == 3 then -- West
                        posCentro.x = posCentro.x - threshold
                        posLadoA.x, posLadoA.y = posLadoA.x - threshold, posLadoA.y - 1
                        posLadoB.x, posLadoB.y = posLadoB.x - threshold, posLadoB.y + 1
                    end
                    
                    tacarMwNaPos(posCentro)
                    
                    if config.modoCerco == 1 then
                        tacarMwNaPos(posLadoA)
                        tacarMwNaPos(posLadoB)
                    end
                end
                
                ultimoDisparoMw = agora
            end
        end
    end
end)

-- MOTOR DE MOVIMENTO (MW NO SEU PÉ)
onPlayerPositionChange(function(newPos, oldPos)
    if not oldPos or oldPos.z ~= posz() then return end
    
    local tile = g_map.getTile(oldPos)
    if config.mwMacroPeAtivo and tile and tile:isWalkable() then
        useWith(config.runeIdMwall or 3180, tile:getTopUseThing())
    end
end)
-- =============================================================================
-- [BLOCO 4] RENDERIZADOR DE TEXTO, POP-UP SEGURO E CLIQUES DA MWALL
-- =============================================================================

function mwallComboBrq_abrirPopUp(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    mwallPopWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    mwallPopWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
    mwallPopWindow.txtEntrada:setText(tostring(config[chaveStorage] or ""))
    mwallPopWindow:show() mwallPopWindow:raise() mwallPopWindow:focus() mwallPopWindow.txtEntrada:focus()
end

function atualizarTextoDosBotoesPainel()
    if not config or not principalWindow or not botoesLateraisUI then return end
    
    principalWindow.btnEditarHotkey:setText("Hotkey do Pe: " .. (config.hotkeyMwall or "F10"))
    principalWindow.btnEditarRuneId:setText("ID da Runa (MW): " .. tostring(config.runeIdMwall or 3180))
    
    principalWindow.swLigaMacroInterno:setOn(config.mwMacroPeAtivo)
    principalWindow.swLigaMacroInterno:setText(config.mwMacroPeAtivo and "Macro Pe: LIGADO" or "Macro Pe: DESLIGADO")
    
    principalWindow.btnEditarHotkeyTarget:setText("Hotkey Alvo: " .. (config.hotkeyTargetMw or "F5"))
    principalWindow.btnEditarDistancia:setText("Bloquear a Frente: " .. tostring(config.squaresThreshold or 2) .. " SQM")
    principalWindow.btnEditarDelayTarget:setText("Delay do Target: " .. tostring(config.delayTargetMw or 100) .. " ms")
    
    principalWindow.swLigaAutoTarget:setOn(config.mwAutoTargetAtivo)
    principalWindow.swLigaAutoTarget:setText(config.mwAutoTargetAtivo and "Auto Alvo: LIGADO" or "Auto Alvo: DESLIGADO")
    
    principalWindow.swLigaCercarAlvo:setOn(config.modoCerco > 0)
    if config.modoCerco == 0 then 
        principalWindow.swLigaCercarAlvo:setText("Modo Cerco: FRENTE (1 MW)")
    elseif config.modoCerco == 1 then 
        principalWindow.swLigaCercarAlvo:setText("Modo Cerco: PARCIAL (3 MW)")
    elseif config.modoCerco == 2 then 
        principalWindow.swLigaCercarAlvo:setText("Modo Cerco: TOTAL (8 MW)") 
    end
    
    botoesLateraisUI.btnLigaMacro:setOn(config.mwMacroPeAtivo)
    botoesLateraisUI.btnLigaMacro:setText(config.mwMacroPeAtivo and "MW: ON" or "MW: OFF")
end

botoesLateraisUI.btnLigaMacro.onClick = function() 
    config.mwMacroPeAtivo = not config.mwMacroPeAtivo 
    atualizarTextoDosBotoesPainel() 
end

botoesLateraisUI.btnAbrePainel.onClick = function() 
    principalWindow:show() principalWindow:raise() principalWindow:focus() 
    atualizarTextoDosBotoesPainel() 
end

principalWindow.btnEditarHotkey.onClick = function() mwallComboBrq_abrirPopUp("hotkeyMwall", "Hotkey do Pe") end
principalWindow.btnEditarRuneId.onClick = function() mwallComboBrq_abrirPopUp("runeIdMwall", "ID da Runa") end

principalWindow.swLigaMacroInterno.onClick = function() 
    config.mwMacroPeAtivo = not config.mwMacroPeAtivo 
    atualizarTextoDosBotoesPainel() 
end

principalWindow.btnEditarHotkeyTarget.onClick = function() mwallComboBrq_abrirPopUp("hotkeyTargetMw", "Hotkey do Target") end
principalWindow.btnEditarDistancia.onClick = function() mwallComboBrq_abrirPopUp("squaresThreshold", "Quantidade de SQM") end
principalWindow.btnEditarDelayTarget.onClick = function() mwallComboBrq_abrirPopUp("delayTargetMw", "Delay em Milissegundos") end

principalWindow.swLigaAutoTarget.onClick = function()
    config.mwAutoTargetAtivo = not config.mwAutoTargetAtivo
    atualizarTextoDosBotoesPainel()
end

principalWindow.swLigaCercarAlvo.onClick = function()
    config.modoCerco = config.modoCerco + 1 
    if config.modoCerco > 2 then config.modoCerco = 0 end 
    atualizarTextoDosBotoesPainel()
end

principalWindow.closeBtn.onClick = function() principalWindow:hide() end
mwallPopWindow.btnCancelar.onClick = function() mwallPopWindow:hide() end

mwallPopWindow.btnConfirmar.onClick = function()
    local ent = mwallPopWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" then
        if campoModeloEditandoVal == "runeIdMwall" or campoModeloEditandoVal == "squaresThreshold" or campoModeloEditandoVal == "delayTargetMw" then
            local valNum = tonumber(ent)
            if campoModeloEditandoVal == "delayTargetMw" then config[campoModeloEditandoVal] = valNum or 100 else config[campoModeloEditandoVal] = valNum or 2 end
        elseif campoModeloEditandoVal == "hotkeyMwall" or campoModeloEditandoVal == "hotkeyTargetMw" then
            local formattedKey = ent:trim() if formattedKey ~= "" then config[campoModeloEditandoVal] = formattedKey end
        end
    end
    mwallPopWindow:hide() atualizarTextoDosBotoesPainel()
end

macro(100, function()
    if principalWindow and principalWindow:isVisible() and principalWindow.lblMarcaDaguaUniversal then
        local eq = math.abs(math.sin(os.clock() * 4)) 
        local tom = math.floor(100 + (155 * eq))
        principalWindow.lblMarcaDaguaUniversal:setColor(string.format("#%02X%02X%02X", tom, tom, tom))
    end
end)

-- VARREDURA DE LIMPEZA RAM EXCLUSIVA DA MWALL CONTRA ELEMENTOS FANTASMAS
for _, child in pairs(widgetRaizDoJogo:getChildren()) do 
    if child:getId() == "janelaMwallPainel" and child ~= principalWindow then child:destroy() end 
    if child:getId() == "janelaMwallPop" and child ~= mwallPopWindow then child:destroy() end
end

atualizarTextoDosBotoesPainel()

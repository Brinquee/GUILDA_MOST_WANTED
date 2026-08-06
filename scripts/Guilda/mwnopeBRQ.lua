local widgetRaizDoJogo = g_ui.getRootWidget()
local idPainelExemplo = "janelaMwallPainel"
local idPainelEditExemplo = "janelaMwallPop"

-- =============================================================================
-- [BLOCO 1] ARMAZENAMENTO DE DADOS UNIFICADO (STORAGE GLOBAL DA MWALL CORRIGIDO)
-- =============================================================================
setDefaultTab("guild")

if not storage.mwallPainelConfig then
    storage.mwallPainelConfig = {}
end

if storage.mwallPainelConfig.macroAtiva == nil then storage.mwallPainelConfig.macroAtiva = false end
if storage.mwallPainelConfig.autoTargetAtivo == nil then storage.mwallPainelConfig.autoTargetAtivo = false end
if storage.mwallPainelConfig.modoCerco == nil then storage.mwallPainelConfig.modoCerco = 0 end
if not storage.mwallPainelConfig.hotkeyMwall then storage.mwallPainelConfig.hotkeyMwall = "F10" end
if not storage.mwallPainelConfig.runeIdMwall then storage.mwallPainelConfig.runeIdMwall = 3180 end
if not storage.mwallPainelConfig.hotkeyTargetMw then storage.mwallPainelConfig.hotkeyTargetMw = "F5" end
if not storage.mwallPainelConfig.squaresThreshold then storage.mwallPainelConfig.squaresThreshold = 2 end
if not storage.mwallPainelConfig.delayTargetMw then storage.mwallPainelConfig.delayTargetMw = 100 end

-- =============================================================================
-- [BLOCO 2] DESIGN DO PAINEL PRINCIPAL (AUMENTADO PARA SECAO DE CERCO E DELAY)
-- =============================================================================
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaMwallPainel\n" ..
"  !text: tr('Combo MW - BRQ')\n" ..
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

-- =============================================================================
-- [BLOCO 3] DESIGN DO POP-UP SEGURO DA MWALL
-- =============================================================================
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
local popUpWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
principalWindow:hide()
popUpWindow:hide()
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

-- =============================================================================
-- [BLOCO 5] LOGICA DE METRALHAR MW NO ALVO E ATUALIZACOES
-- =============================================================================
local config = storage.mwallPainelConfig
local campoModeloEditandoVal = ""
local ultimoDisparoMw = 0

-- Funcao auxiliar para tentar tacar MW em uma coordenada especifica
local function tacarMwNaPos(pos)
    local tile = g_map.getTile(pos)
    if tile then
        useWith(config.runeIdMwall or 3180, tile:getTopUseThing())
    end
end

-- 1. Captura para ligar/desligar o Pe via hotkey e ativar a do Target por clique unico
onKeyPress(function(keys)
    if modules.game_console:isChatEnabled() then return end
    
    if config.hotkeyMwall and keys:lower() == config.hotkeyMwall:lower() then
        config.macroAtiva = not config.macroAtiva
        atualizarTextoDosBotoesPainel()
    end
    
    if config.hotkeyTargetMw and keys:lower() == config.hotkeyTargetMw:lower() then
        config.autoTargetAtivo = not config.autoTargetAtivo
        atualizarTextoDosBotoesPainel()
    end
end)

-- 2. Macro Principal com os 3 Modos Selecionaveis e Delay por Tempo
macro(20, function()
    if modules.game_console:isChatEnabled() then return end
    
    local deveAtacar = config.autoTargetAtivo
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

-- 3. Macro de movimento (MW no seu Pe)
onPlayerPositionChange(function(newPos, oldPos)
    if not oldPos or oldPos.z ~= posz() then return end
    
    local tile = g_map.getTile(oldPos)
    if config.macroAtiva and tile and tile:isWalkable() then
        useWith(config.runeIdMwall or 3180, tile:getTopUseThing())
    end
end)
function dispararAberturaPopUpSeguro(chaveStorage, nomeDoCampoNoMenu)
    campoModeloEditandoVal = chaveStorage
    popUpWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    popUpWindow.lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
    
    local valorAtualNaMemoria = tostring(config[chaveStorage] or "")
    popUpWindow.txtEntrada:setText(valorAtualNaMemoria)
    
    popUpWindow:show()
    popUpWindow:raise()
    popUpWindow:focus()
    popUpWindow.txtEntrada:focus()
end

function atualizarTextoDosBotoesPainel()
    if not config or not principalWindow or not botoesLateraisUI then return end
    
    local hkPe = config.hotkeyMwall or "F10"
    local runeId = config.runeIdMwall or 3180
    local hkAlvo = config.hotkeyTargetMw or "F5"
    local threshold = config.squaresThreshold or 2
    local delayMs = config.delayTargetMw or 100

    -- Secao do Pe
    principalWindow.btnEditarHotkey:setText("Hotkey do Pe: " .. hkPe)
    principalWindow.btnEditarRuneId:setText("ID da Runa (MW): " .. tostring(runeId))
    principalWindow.swLigaMacroInterno:setOn(config.macroAtiva)
    principalWindow.swLigaMacroInterno:setText(config.macroAtiva and "Macro Pe: LIGADO" or "Macro Pe: DESLIGADO")
    
    -- Secao do Alvo
    principalWindow.btnEditarHotkeyTarget:setText("Hotkey Alvo: " .. hkAlvo)
    principalWindow.btnEditarDistancia:setText("Bloquear a Frente: " .. tostring(threshold) .. " SQM")
    principalWindow.btnEditarDelayTarget:setText("Delay do Target: " .. tostring(delayMs) .. " ms")
    
    principalWindow.swLigaAutoTarget:setOn(config.autoTargetAtivo)
    principalWindow.swLigaAutoTarget:setText(config.autoTargetAtivo and "Auto Alvo: LIGADO" or "Auto Alvo: DESLIGADO")
    
    -- Exibe o modo atual de forma ciclica com base no numero salvo (0, 1 ou 2)
    principalWindow.swLigaCercarAlvo:setOn(config.modoCerco > 0)
    if config.modoCerco == 0 then
        principalWindow.swLigaCercarAlvo:setText("Modo Cerco: FRENTE (1 MW)")
    elseif config.modoCerco == 1 then
        principalWindow.swLigaCercarAlvo:setText("Modo Cerco: PARCIAL (3 MW)")
    elseif config.modoCerco == 2 then
        principalWindow.swLigaCercarAlvo:setText("Modo Cerco: TOTAL (8 MW)")
    end
    
    -- Botao da barra
    botoesLateraisUI.btnLigaMacro:setOn(config.macroAtiva)
    botoesLateraisUI.btnLigaMacro:setText(config.macroAtiva and "MW: ON" or "MW: OFF")
end

-- =============================================================================
-- [BLOCO 6] CAPTURA DE EVENTOS DE CLIQUES E ENCERRAMENTOS
-- =============================================================================
botoesLateraisUI.btnLigaMacro.onClick = function() 
    config.macroAtiva = not config.macroAtiva 
    atualizarTextoDosBotoesPainel() 
end

botoesLateraisUI.btnAbrePainel.onClick = function() 
    principalWindow:show() 
    principalWindow:raise() 
    principalWindow:focus() 
    atualizarTextoDosBotoesPainel() 
end

principalWindow.btnEditarHotkey.onClick = function() dispararAberturaPopUpSeguro("hotkeyMwall", "Hotkey do Pe") end
principalWindow.btnEditarRuneId.onClick = function() dispararAberturaPopUpSeguro("runeIdMwall", "ID da Runa") end

principalWindow.swLigaMacroInterno.onClick = function() 
    config.macroAtiva = not config.macroAtiva 
    atualizarTextoDosBotoesPainel() 
end

principalWindow.btnEditarHotkeyTarget.onClick = function() dispararAberturaPopUpSeguro("hotkeyTargetMw", "Hotkey do Target") end
principalWindow.btnEditarDistancia.onClick = function() dispararAberturaPopUpSeguro("squaresThreshold", "Quantidade de SQM") end
principalWindow.btnEditarDelayTarget.onClick = function() dispararAberturaPopUpSeguro("delayTargetMw", "Delay em Milissegundos") end

principalWindow.swLigaAutoTarget.onClick = function()
    config.autoTargetAtivo = not config.autoTargetAtivo
    atualizarTextoDosBotoesPainel()
end

-- Alterna ciclicamente entre as 3 opcoes ao clicar
principalWindow.swLigaCercarAlvo.onClick = function()
    config.modoCerco = config.modoCerco + 1
    if config.modoCerco > 2 then config.modoCerco = 0 end
    atualizarTextoDosBotoesPainel()
end

principalWindow.closeBtn.onClick = function() principalWindow:hide() end

popUpWindow.btnCancelar.onClick = function() popUpWindow:hide() end
popUpWindow.btnConfirmar.onClick = function()
    local entradaDigitada = popUpWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" then
        if campoModeloEditandoVal == "runeIdMwall" or campoModeloEditandoVal == "squaresThreshold" or campoModeloEditandoVal == "delayTargetMw" then
            local valNum = tonumber(entradaDigitada)
            if campoModeloEditandoVal == "delayTargetMw" then
                config[campoModeloEditandoVal] = valNum or 100
            else
                config[campoModeloEditandoVal] = valNum or 2
            end
        elseif campoModeloEditandoVal == "hotkeyMwall" or campoModeloEditandoVal == "hotkeyTargetMw" then
            local formattedKey = entradaDigitada:trim()
            if formattedKey ~= "" then
                config[campoModeloEditandoVal] = formattedKey
            end
        end
    end
    popUpWindow:hide() 
    atualizarTextoDosBotoesPainel()
end

macro(100, function()
    if principalWindow and principalWindow:isVisible() and principalWindow.lblMarcaDaguaUniversal then
        local equacaoSeno = math.abs(math.sin(os.clock() * 4))
        local tomDeCinza = math.floor(100 + (155 * equacaoSeno))
        principalWindow.lblMarcaDaguaUniversal:setColor(string.format("#%02X%02X%02X", tomDeCinza, tomDeCinza, tomDeCinza))
    end
end)

atualizarTextoDosBotoesPainel()

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
if not storage.mwallPainelConfig.hotkeyMwall then storage.mwallPainelConfig.hotkeyMwall = "F10" end
if not storage.mwallPainelConfig.runeIdMwall then storage.mwallPainelConfig.runeIdMwall = 3180 end
if not storage.mwallPainelConfig.hotkeyTargetMw then storage.mwallPainelConfig.hotkeyTargetMw = "F5" end
if not storage.mwallPainelConfig.squaresThreshold then storage.mwallPainelConfig.squaresThreshold = 2 end

-- =============================================================================
-- [BLOCO 2] DESIGN DO PAINEL PRINCIPAL (AUMENTADO PARA CABER O NOVO SWITCH)
-- =============================================================================
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaMwallPainel\n" ..
"  !text: tr('Combo MW - BRQ')\n" ..
"  size: 280 470\n" ..
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
"  BotSwitch\n" ..
"    id: swLigaAutoTarget\n" ..
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

-- 1. Captura para ligar/desligar o Pe via hotkey e ativar a do Target por clique unico
onKeyPress(function(keys)
    if modules.game_console:isChatEnabled() then return end
    
    -- Tecla do Macro do Pe
    if config.hotkeyMwall and keys:lower() == config.hotkeyMwall:lower() then
        config.macroAtiva = not config.macroAtiva
        atualizarTextoDosBotoesPainel()
    end
    
    -- Tecla do Macro do Target (Caso queira apenas ligar/desligar o Auto Alvo pelo teclado)
    if config.hotkeyTargetMw and keys:lower() == config.hotkeyTargetMw:lower() then
        config.autoTargetAtivo = not config.autoTargetAtivo
        atualizarTextoDosBotoesPainel()
    end
end)

-- 2. Macro Continuo: Dispara se o interruptor estiver ON ou se a tecla estiver pressionada
macro(100, function()
    if modules.game_console:isChatEnabled() then return end
    
    local deveAtacar = config.autoTargetAtivo
    if config.hotkeyTargetMw and g_keyboard.isKeyPressed(config.hotkeyTargetMw) then
        deveAtacar = true
    end
    
    if deveAtacar then
        local target = g_game.getAttackingCreature()
        if target then
            local targetPos = target:getPosition()
            local targetDir = target:getDirection()
            local mwallTile
            local threshold = config.squaresThreshold or 2
            
            if targetDir == 0 then -- North
                targetPos.y = targetPos.y - threshold
            elseif targetDir == 1 then -- East
                targetPos.x = targetPos.x + threshold
            elseif targetDir == 2 then -- South
                targetPos.y = targetPos.y + threshold
            elseif targetDir == 3 then -- West
                targetPos.x = targetPos.x - threshold
            end
            
            mwallTile = g_map.getTile(targetPos)
            if mwallTile then
                useWith(config.runeIdMwall or 3180, mwallTile:getTopUseThing())
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

    -- Secao do Pe
    principalWindow.btnEditarHotkey:setText("Hotkey do Pe: " .. hkPe)
    principalWindow.btnEditarRuneId:setText("ID da Runa (MW): " .. tostring(runeId))
    principalWindow.swLigaMacroInterno:setOn(config.macroAtiva)
    principalWindow.swLigaMacroInterno:setText(config.macroAtiva and "Macro Pe: LIGADO" or "Macro Pe: DESLIGADO")
    
    -- Secao do Alvo
    principalWindow.btnEditarHotkeyTarget:setText("Hotkey Alvo: " .. hkAlvo)
    principalWindow.btnEditarDistancia:setText("Bloquear a Frente: " .. tostring(threshold) .. " SQM")
    principalWindow.swLigaAutoTarget:setOn(config.autoTargetAtivo)
    principalWindow.swLigaAutoTarget:setText(config.autoTargetAtivo and "Auto Alvo: LIGADO" or "Auto Alvo: DESLIGADO")
    
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

principalWindow.swLigaAutoTarget.onClick = function()
    config.autoTargetAtivo = not config.autoTargetAtivo
    atualizarTextoDosBotoesPainel()
end

principalWindow.closeBtn.onClick = function() principalWindow:hide() end

popUpWindow.btnCancelar.onClick = function() popUpWindow:hide() end
popUpWindow.btnConfirmar.onClick = function()
    local entradaDigitada = popUpWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" then
        if campoModeloEditandoVal == "runeIdMwall" or campoModeloEditandoVal == "squaresThreshold" then
            config[campoModeloEditandoVal] = tonumber(entradaDigitada) or 2
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

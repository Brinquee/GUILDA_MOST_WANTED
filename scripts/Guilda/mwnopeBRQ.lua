local widgetRaizDoJogo = g_ui.getRootWidget()

setDefaultTab("guild")

if not storage.mwallPainelConfig then
    storage.mwallPainelConfig = {}
end

local config = storage.mwallPainelConfig

-- BLINDAGEM DE STORAGE: Valores padroes limpos de acentos
if config.mwMacroPeAtivo == nil then config.mwMacroPeAtivo = false end
if config.mwAutoTargetAtivo == nil then config.mwAutoTargetAtivo = false end
if config.growthMacroPeAtivo == nil then config.growthMacroPeAtivo = false end
if config.growthAutoTargetAtivo == nil then config.growthAutoTargetAtivo = false end

if config.modoCerco == nil then config.modoCerco = 0 end -- 0=Frente, 1=Parcial, 2=Total, 3=Rastro, 4=Pe Target
if config.mostrarPainelStatus == nil then config.mostrarPainelStatus = true end

if config.mostrarIconePe == nil then config.mostrarIconePe = true end
if config.mostrarIconeTarget == nil then config.mostrarIconeTarget = true end
if config.mostrarIconeGrowth == nil then config.mostrarIconeGrowth = true end

if not config.runeIdMwall then config.runeIdMwall = 3180 end
if not config.runeIdMato then config.runeIdMato = 3156 end
if not config.squaresThreshold then config.squaresThreshold = 2 end
if not config.delayTargetMw then config.delayTargetMw = 100 end
if not config.hotkeyMudarModo then config.hotkeyMudarModo = "" end

-- Inicializadores de memoria de posicao X e Y salvos no storage do vBot
if not config.painelStatusX then config.painelStatusX = 200 end
if not config.painelStatusY then config.painelStatusY = 150 end
if not config.iconePeX then config.iconePeX = 300 end
if not config.iconePeY then config.iconePeY = 290 end
if not config.iconeTargetX then config.iconeTargetX = 340 end
if not config.iconeTargetY then config.iconeTargetY = 290 end
if not config.iconeGrowthPeX then config.iconeGrowthPeX = 300 end
if not config.iconeGrowthPeY then config.iconeGrowthPeY = 330 end
if not config.iconeGrowthX then config.iconeGrowthX = 340 end
if not config.iconeGrowthY then config.iconeGrowthY = 330 end

-- LAYOUT VERTICAL CLÁSSICO RETRO COMPATÍVEL
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaMwallPainel\n" ..
"  size: 280 360\n" ..
"  @onEscape: self:hide()\n" ..
"  layout: anchor\n" ..
"  Label\n" ..
"    id: lblSecaoUm\n" ..
"    text: == CONFIGURACOES DE RUNAS ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnEditarRuneId\n" ..
"    anchors.top: lblSecaoUm.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarRuneIdMato\n" ..
"    anchors.top: btnEditarRuneId.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnHotkeyMudarModo\n" ..
"    anchors.top: btnEditarRuneIdMato.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarDistancia\n" ..
"    anchors.top: btnHotkeyMudarModo.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnEditarDelayTarget\n" ..
"    anchors.top: btnEditarDistancia.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnMudarModoCerco\n" ..
"    anchors.top: btnEditarDelayTarget.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 24\n" ..
"  CheckBox\n" ..
"    id: chkMostrarPainelStatus\n" ..
"    text: Mostrar Painel de Status na Tela\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #44ff44\n" ..
"    anchors.top: btnMudarModoCerco.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 8\n" ..
"    height: 16\n" ..
"  CheckBox\n" ..
"    id: chkMostrarIconePe\n" ..
"    text: Mostrar Icones Mwall (MW)\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #e6bc22\n" ..
"    anchors.top: chkMostrarPainelStatus.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 16\n" ..
"  CheckBox\n" ..
"    id: chkMostrarIconeTarget\n" ..
"    text: Mostrar Icones Mato (Growth)\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #e6bc22\n" ..
"    anchors.top: chkMostrarIconePe.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 6\n" ..
"    height: 16\n" ..
"  Label\n" ..
"    id: lblMarcaDaguaUniversal\n" ..
"    text: >> BRINQUE MACROS <<\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: closeBtn.top\n" ..
"    anchors.horizontalCenter: parent.horizontalCenter\n" ..
"    margin-bottom: 6\n" ..
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
"  id: javaMwallPop\n" ..
"  !text: tr('Editar Campo')\n" ..
"  size: 260 130\n" ..
"  anchors.centerIn: parent\n" ..
"  @onEscape: self:hide()\n" ..
"  layout: anchor\n" ..
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
-- =============================================================================
-- [MWALL - PARTE 2 DE 4] INTERFACE DO PAINEL ARRASTAVEL E BOTAO LATERAL SOLO
-- =============================================================================
local designStatusTransparenteOTUI = "UIWindow\n" ..
"  id: janelaMwallStatusTransparente\n" ..
"  size: 200 30\n" ..
"  background-color: #00000033\n" ..
"  border: 0 alpha\n" ..
"  image-border: 0\n" ..
"  phantom: false\n" ..
"  draggable: true\n" ..
"  layout: anchor\n" ..
"\n" ..
"  Label\n" ..
"    id: lblTextoStatusModo\n" ..
"    text: Modo: Carregando...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #44ff44\n" ..
"    anchors.fill: parent\n" ..
"    text-align: center\n"

local mwallStatusWindow = setupUI(designStatusTransparenteOTUI, widgetRaizDoJogo)
mwallStatusWindow:hide()

mwallStatusWindow:setX(config.painelStatusX)
mwallStatusWindow:setY(config.painelStatusY)

local function salvarPosicaoDoPainelStatus(widget)
    if not widget then return end
    config.painelStatusX = widget:getX()
    config.painelStatusY = widget:getY()
end

mwallStatusWindow.onGeometryChange = function(w) salvarPosicaoDoPainelStatus(w) end
mwallStatusWindow.onMove = function(w) salvarPosicaoDoPainelStatus(w) end

local painelDaAbaGuild = getTab("guild")
if painelDaAbaGuild:recursiveGetChildById("panelBotoesMwallNativos") then
    painelDaAbaGuild:recursiveGetChildById("panelBotoesMwallNativos"):destroy()
end

-- CRIA APENAS O SETUP MW: Sem botoes de ativacao cinzas por texto na aba lateral
local botoesLateraisUI = setupUI([[
Panel
  id: panelBotoesMwallNativos
  height: 22
  margin-top: 5
  layout:
    type: verticalBox

  Button
    id: btnAbrePainel
    text: Setup MW
    height: 20
    font: verdana-11px-rounded
]], painelDaAbaGuild)

local campoModeloEditandoVal = ""
local ultimoDisparoMw = 0
local ultimaPosicaoDoTarget = nil
local ultimoTargetIdRastreado = 0

local function tacarRunaNaPos(pos, idRunaForcada)
    if not pos then return end
    local tile = g_map.getTile(pos)
    if tile then useWith(idRunaForcada or config.runeIdMwall or 3180, tile:getTopUseThing()) end
end
-- =============================================================================
-- [MWALL - PARTE 3 DE 4] MOTORES REAIS ATRELADOS AOS ICONES NATIVOS (SEM COMPLICACOES)
-- =============================================================================

-- DETECTOR DINÂMICO: Le o storage a cada clique, aceitando mudancas na hora sem precisar de reload
onKeyPress(function(keys)
    if modules.game_console:isChatEnabled() then return end
    
    local hotkeyAtual = config.hotkeyMudarModo or "F6"
    
    if keys:lower() == hotkeyAtual:lower() then
        config.modoCerco = config.modoCerco + 1
        if config.modoCerco > 4 then config.modoCerco = 0 end
        atualizarTextoDosBotoesPainel()
        print("[Mwall] Modo alterado via hotkey para: Modo " .. config.modoCerco)
    end
end)

local function dispararGeometriaDeCombate(idRunaAlvo)
    local target = g_game.getAttackingCreature()
    if not target then
        ultimaPosicaoDoTarget = nil
        ultimoTargetIdRastreado = 0
        return
    end

    local targetPos = target:getPosition()
    local targetId = target:getId()

    if config.modoCerco == 4 then
        tacarRunaNaPos({x = targetPos.x, y = targetPos.y, z = targetPos.z}, idRunaAlvo)
    elseif config.modoCerco == 3 then
        if ultimoTargetIdRastreado == targetId and ultimaPosicaoDoTarget then
            if ultimaPosicaoDoTarget.x ~= targetPos.x or ultimaPosicaoDoTarget.y ~= targetPos.y or ultimaPosicaoDoTarget.z ~= targetPos.z then
                tacarRunaNaPos({x = ultimaPosicaoDoTarget.x, y = ultimaPosicaoDoTarget.y, z = ultimaPosicaoDoTarget.z}, idRunaAlvo)
            end
        end
        ultimaPosicaoDoTarget = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
        ultimoTargetIdRastreado = targetId
    else
        local targetDir = target:getDirection()
        local threshold = config.squaresThreshold or 2

        if config.modoCerco == 2 then
            local direcoes8 = {
                {x=-1, y=-1}, {x=0, y=-1}, {x=1, y=-1},
                {x=-1, y=0},               {x=1, y=0},
                {x=-1, y=1},  {x=0, y=1},  {x=1, y=1}
            }
            for _, offset in ipairs(direcoes8) do
                tacarRunaNaPos({x = targetPos.x + offset.x, y = targetPos.y + offset.y, z = targetPos.z}, idRunaAlvo)
            end
        else
            local posCentro = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
            local posLadoA = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
            local posLadoB = {x = targetPos.x, y = targetPos.y, z = targetPos.z}

            if targetDir == 0 then
                posCentro.y = posCentro.y - threshold
                posLadoA.x, posLadoA.y = posLadoA.x - 1, posLadoA.y - threshold
                posLadoB.x, posLadoB.y = posLadoB.x + 1, posLadoB.y - threshold
            elseif targetDir == 1 then
                posCentro.x = posCentro.x + threshold
                posLadoA.x, posLadoA.y = posLadoA.x + threshold, posLadoA.y - 1
                posLadoB.x, posLadoB.y = posLadoB.x + threshold, posLadoB.y + 1
            elseif targetDir == 2 then
                posCentro.y = posCentro.y + threshold
                posLadoA.x, posLadoA.y = posLadoA.x - 1, posLadoA.y + threshold
                posLadoB.x, posLadoB.y = posLadoB.x + 1, posLadoB.y + threshold
            elseif targetDir == 3 then
                posCentro.x = posCentro.x - threshold
                posLadoA.x, posLadoA.y = posLadoA.x - threshold, posLadoA.y - 1
                posLadoB.x, posLadoB.y = posLadoB.x - threshold, posLadoB.y + 1
            end

            tacarRunaNaPos(posCentro, idRunaAlvo)
            if config.modoCerco == 1 then
                tacarRunaNaPos(posLadoA, idRunaAlvo)
                tacarRunaNaPos(posLadoB, idRunaAlvo)
            end
        end
    end
end

-- AS 4 ENGINES DOS MACROS COM AS FUNÇÕES CONECTADAS DE VERDADE
-- Nomes omitidos para nao gerar botoes cinzas na barra lateral do bot
local macroPeMw = macro(100, function() end)

local macroTargetMw = macro(20, function()
    if modules.game_console:isChatEnabled() then return end
    local agora = os.clock() * 1000
    if agora - ultimoDisparoMw >= (config.delayTargetMw or 100) then
        dispararGeometriaDeCombate(config.runeIdMwall or 3180)
        ultimoDisparoMw = agora
    end
end)

local macroPeGrowth = macro(100, function() end)

local macroTargetGrowth = macro(20, function()
    if modules.game_console:isChatEnabled() then return end
    local agora = os.clock() * 1000
    if agora - ultimoDisparoMw >= (config.delayTargetMw or 100) then
        dispararGeometriaDeCombate(config.runeIdMato or 3156)
        ultimoDisparoMw = agora
    end
end)

-- MOTOR DE RASTRO DE MOVIMENTO NO PROPRIO PE SENSE REAIS
onPlayerPositionChange(function(newPos, oldPos)
    if not oldPos or oldPos.z ~= posz() then return end
    local tile = g_map.getTile(oldPos)
    if not tile or not tile:isWalkable() then return end
    
    if macroPeMw:isOn() then
        tacarRunaNaPos(oldPos, config.runeIdMwall or 3180)
    elseif macroPeGrowth:isOn() then
        tacarRunaNaPos(oldPos, config.runeIdMato or 3156)
    end
end)

-- CRIAÇÃO DOS ÍCONES PASSANDO DIRETAMENTE OS ATIVADORES ANÔNIMOS REAIS CONECTADOS
local iconePeMw = addIcon("IconPeMw", {item = config.runeIdMwall or 3180, text = "Pe"}, macroPeMw)
iconePeMw:breakAnchors()

local iconeTargetMw = addIcon("IconTargetMw", {item = config.runeIdMwall or 3180, text = "TG"}, macroTargetMw)
iconeTargetMw:breakAnchors()

local iconePeGrowth = addIcon("IconPeGrowth", {item = config.runeIdMato or 3156, text = "Pe"}, macroPeGrowth)
iconePeGrowth:breakAnchors()

local iconeTargetGrowth = addIcon("IconTargetGrowth", {item = config.runeIdMato or 3156, text = "TG"}, macroTargetGrowth)
iconeTargetGrowth:breakAnchors()

-- Sincroniza posicoes iniciais salvas do storage
iconePeMw:move(config.iconePeX, config.iconePeY)
iconeTargetMw:move(config.iconeTargetX, config.iconeTargetY)
iconePeGrowth:move(config.iconeGrowthPeX, config.iconeGrowthPeY)
iconeTargetGrowth:move(config.iconeGrowthX, config.iconeGrowthY)

-- INTERCEPTOR GERAL DO STORAGE E TRAVAS MUTUAS NATIVAS ANTI-STACK
macro(50, function()
    config.mwMacroPeAtivo = macroPeMw:isOn()
    config.mwAutoTargetAtivo = macroTargetMw:isOn()
    config.growthMacroPeAtivo = macroPeGrowth:isOn()
    config.growthAutoTargetAtivo = macroTargetGrowth:isOn()

    if macroPeMw:isOn() and macroPeGrowth:isOn() then macroPeGrowth:setOff() end
    if macroTargetMw:isOn() and macroTargetGrowth:isOn() then macroTargetGrowth:setOff() end
    if macroPeGrowth:isOn() and macroPeMw:isOn() then macroPeMw:setOff() end
    if macroTargetGrowth:isOn() and macroTargetMw:isOn() then macroTargetMw:setOff() end
end)

-- ENGENHARIA DO GANCHO GRUDADO
local function aplicarGanchoDeArrastoSincronizado(widgetPe, widgetTarget, chaveX, chaveY, chaveTargetX, chaveTargetY)
    local function sincronizar(w)
        if not w then return end
        config[chaveX] = w:getX()
        config[chaveY] = w:getY()
        config[chaveTargetX] = config[chaveX] + 40
        config[chaveTargetY] = config[chaveY]
        if widgetTarget then widgetTarget:move(config[chaveTargetX], config[chaveTargetY]) end
    end
    widgetPe.onGeometryChange = function(w) sincronizar(w) end
    widgetPe.onMove = function(w) sincronizar(w) end
    
    widgetTarget.onGeometryChange = function(w) if w then config[chaveTargetX] = w:getX() config[chaveTargetY] = w:getY() end end
    widgetTarget.onMove = function(w) if w then config[chaveTargetX] = w:getX() config[chaveTargetY] = w:getY() end end
end

aplicarGanchoDeArrastoSincronizado(iconePeMw, iconeTargetMw, "iconePeX", "iconePeY", "iconeTargetX", "iconeTargetY")
aplicarGanchoDeArrastoSincronizado(iconePeGrowth, iconeTargetGrowth, "iconeGrowthPeX", "iconeGrowthPeY", "iconeGrowthX", "iconeGrowthY")

-- LOOP SECUNDÁRIO DE EXIBIÇÃO DE TEXTOS E STATUS DO ALVO
macro(100, function()
    local targetAtivo = g_game.getAttackingCreature()
    
    if config.mostrarPainelStatus and targetAtivo then
        if mwallStatusWindow then
            local textoMapeado = "Carregando..."
            if config.modoCerco == 0 then textoMapeado = "Modo: FRENTE"
            elseif config.modoCerco == 1 then textoMapeado = "Modo: PARCIAL"
            elseif config.modoCerco == 2 then textoMapeado = "Modo: TOTAL"
            elseif config.modoCerco == 3 then textoMapeado = "Modo: RASTRO"
            elseif config.modoCerco == 4 then textoMapeado = "Modo: PE TARGET" end
            mwallStatusWindow.lblTextoStatusModo:setText(textoMapeado)
            mwallStatusWindow:show()
        end
    else
        if mwallStatusWindow then mwallStatusWindow:hide() end
    end

    if iconePeMw and iconeTargetMw then
        if config.mostrarIconePe then iconePeMw:show() iconeTargetMw:show() else iconePeMw:hide() iconeTargetMw:hide() end
        if iconePeMw.item then iconePeMw.item:setId(config.runeIdMwall or 3180) end
        if iconeTargetMw.item then iconeTargetMw.item:setId(config.runeIdMwall or 3180) end
    end
    
    if iconePeGrowth and iconeTargetGrowth then
        if config.mostrarIconeGrowth then iconePeGrowth:show() iconeTargetGrowth:show() else iconePeGrowth:hide() iconeTargetGrowth:hide() end
        if iconePeGrowth.item then iconePeGrowth.item:setId(config.runeIdMato or 3156) end
        if iconeTargetGrowth.item then iconeTargetGrowth.item:setId(config.runeIdMato or 3156) end
    end
end)

-- =============================================================================
-- [MWALL - PARTE 4 DE 4] INTERFACES DE POP-UP, CONFIGURACOES E LIMPEZA PREVENTIVA RAM
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
    
    principalWindow.btnEditarRuneId:setText("ID da Runa (MW): " .. tostring(config.runeIdMwall or 3180))
    principalWindow.btnEditarRuneIdMato:setText("ID da Runa (Mato): " .. tostring(config.runeIdMato or 3156))
    principalWindow.btnHotkeyMudarModo:setText("Hotkey Trocar Modo: " .. (config.hotkeyMudarModo or "F6"))
    principalWindow.btnEditarDistancia:setText("Bloquear a Frente: " .. tostring(config.squaresThreshold or 2) .. " SQM")
    principalWindow.btnEditarDelayTarget:setText("Delay do Target: " .. tostring(config.delayTargetMw or 100) .. " ms")
    
    -- Sincroniza perfeitamente o estado de todas as caixinhas nomeadas explicativas
    principalWindow.chkMostrarPainelStatus:setChecked(config.mostrarPainelStatus == true)
    principalWindow.chkMostrarIconePe:setChecked(config.mostrarIconePe == true)
    principalWindow.chkMostrarIconeTarget:setChecked(config.mostrarIconeGrowth == true)
    
    if config.modoCerco == 0 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: FRENTE (1 MW)")
    elseif config.modoCerco == 1 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: PARCIAL (3 MW)")
    elseif config.modoCerco == 2 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: TOTAL (8 MW)") 
    elseif config.modoCerco == 3 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: RASTRO (Onde estava)") 
    elseif config.modoCerco == 4 then 
        principalWindow.btnMudarModoCerco:setText("Modo Cerco: PE DO TARGET (Continuo)") 
    end
end

-- CLIQUES DO PAINEL PRINCIPAL DE SETUP
botoesLateraisUI.btnAbrePainel.onClick = function() 
    principalWindow:show() principalWindow:raise() principalWindow:focus() 
    atualizarTextoDosBotoesPainel() 
end

principalWindow.btnEditarRuneId.onClick = function() mwallComboBrq_abrirPopUp("runeIdMwall", "ID da Runa MW") end
principalWindow.btnEditarRuneIdMato.onClick = function() mwallComboBrq_abrirPopUp("runeIdMato", "ID da Runa Mato") end
principalWindow.btnHotkeyMudarModo.onClick = function() mwallComboBrq_abrirPopUp("hotkeyMudarModo", "Hotkey Trocar Modo") end
principalWindow.btnEditarDistancia.onClick = function() mwallComboBrq_abrirPopUp("squaresThreshold", "Quantidade de SQM") end
principalWindow.btnEditarDelayTarget.onClick = function() mwallComboBrq_abrirPopUp("delayTargetMw", "Delay em Milissegundos") end

principalWindow.btnMudarModoCerco.onClick = function()
    config.modoCerco = config.modoCerco + 1 
    if config.modoCerco > 4 then config.modoCerco = 0 end
    atualizarTextoDosBotoesPainel()
end

principalWindow.chkMostrarPainelStatus.onClick = function(w)
    local val = not w:isChecked()
    w:setChecked(val)
    config.mostrarPainelStatus = val
end

principalWindow.chkMostrarIconePe.onClick = function(w)
    local val = not w:isChecked()
    w:setChecked(val)
    config.mostrarIconePe = val
end

principalWindow.chkMostrarIconeTarget.onClick = function(w)
    local val = not w:isChecked()
    w:setChecked(val)
    config.mostrarIconeGrowth = val
end

principalWindow.closeBtn.onClick = function() principalWindow:hide() end
mwallPopWindow.btnCancelar.onClick = function() mwallPopWindow:hide() end

mwallPopWindow.btnConfirmar.onClick = function()
    local ent = mwallPopWindow.txtEntrada:getText()
    if campoModeloEditandoVal ~= "" then
        if campoModeloEditandoVal == "runeIdMwall" or campoModeloEditandoVal == "runeIdMato" or campoModeloEditandoVal == "squaresThreshold" or campoModeloEditandoVal == "delayTargetMw" then
            local valNum = tonumber(ent)
            if campoModeloEditandoVal == "delayTargetMw" then 
                config[campoModeloEditandoVal] = valNum or 100 
            elseif campoModeloEditandoVal == "runeIdMato" then
                config[campoModeloEditandoVal] = valNum or 3156
            elseif campoModeloEditandoVal == "runeIdMwall" then
                config[campoModeloEditandoVal] = valNum or 3180
            else 
                config[campoModeloEditandoVal] = valNum or 2 
            end
        elseif campoModeloEditandoVal == "hotkeyMudarModo" then
            local formattedKey = ent:trim() 
            if formattedKey ~= "" then config[campoModeloEditandoVal] = formattedKey end
        end
    end
    mwallPopWindow:hide() atualizarTextoDosBotoesPainel()
end

-- MOTOR DE ANIMACAO DA LOGO EM MACRO ANONIMO COMPATÍVEL
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
    if child:getId() == "janelaMwallStatusTransparente" and child ~= mwallStatusWindow then child:destroy() end
end

atualizarTextoDosBotoesPainel()

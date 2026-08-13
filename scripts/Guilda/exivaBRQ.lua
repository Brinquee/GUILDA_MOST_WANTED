setDefaultTab("Cave")

local panelName = "exivaBrinquePremium"
if type(storage[panelName]) ~= "table" then
    storage[panelName] = {
        macroAtiva = false,
        mode = "none",
        customTarget = "",
        guildTarget = "",
        teamList = {},
        blackList = {},
        idIcone = 11104,
        delayMuted = 0.5,
        opcoes = {
            painelAtivo = true,
            priorizarTarget = true,
            mostrarMiniBattle = true
        },
        teclas = {
            target = "Home",
            team = "End",
            cancelar = "NumLock"
        },
        posicaoMestre = { x = 300, y = 200 },
        posicaoBattle = { x = 100, y = 150 }
    }
end

local config = storage[panelName]
local CAMINHO_FOTO_SETA = "/bot/CUSTOM_PREMIUM/imagens/stylesense.png"

local currentTab = "enemy"
local timeoutPainelJanela = 0
local delayExivaTimer = 0
local campoExivaEditandoVal = ""
local campoExivaEditandoSubVal = nil

local painelDaAbaCave = getTab("Cave")
if painelDaAbaCave:recursiveGetChildById("exivaHunterBrinque_panelBotoesExivaNativos") then
    painelDaAbaCave:recursiveGetChildById("exivaHunterBrinque_panelBotoesExivaNativos"):destroy()
end

local botoesLateraisUI = setupUI([[
Panel
  id: exivaHunterBrinque_panelBotoesExivaNativos
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4

  BotSwitch
    id: btnMestreExivaOnOffSwitch
    text: Exiva: On/Off
    width: 85
    color: #44ff44

  Button
    id: btnSetupExiva
    text: Config Painel
    width: 85
    color: #00bfff
]], painelDaAbaCave)

local widgetRaizDoJogo = g_ui.getRootWidget()
-- =============================================================================
-- [BLOCO 2] DESIGN DA MAINWINDOW MESTRE E POP-UP SEGURO (IDS 100% ISOLADOS)
-- =============================================================================
local designPrincipalOTUI = [[
MainWindow
  id: exivaHunterBrinque_janelaGeralMestre
  size: 500 500
  background-color: #1a1a1aef
  @onEscape: self:hide()

  Label
    id: exivaHunterBrinque_titleBase
    text: PAINEL EXIVA - BRINQUE SCRIPTS
    font: verdana-11px-rounded
    color: #FFFFFF
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    margin-top: -19
    text-align: center
    height: 20
    width: 300

  Panel
    id: exivaHunterBrinque_waveContainer
    anchors.top: exivaHunterBrinque_titleBase.top
    anchors.horizontalCenter: exivaHunterBrinque_titleBase.horizontalCenter
    margin-top: 0
    height: 20
    width: 300
    clipping: true
    phantom: true
    visible: false
    Label
      id: exivaHunterBrinque_titleWave
      text: PAINEL EXIVA - BRINQUE SCRIPTS
      font: verdana-11px-rounded
      color: #FF0000
      anchors.top: parent.top
      anchors.horizontalCenter: parent.horizontalCenter
      text-align: center
      width: 300

  Label
    id: exivaHunterBrinque_lblColunaEsquerda
    text: == ALIADOS / TEAM ==
    font: verdana-11px-rounded
    color: #44ff44
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 15
    width: 220
    text-align: center

  ScrollablePanel
    id: exivaHunterBrinque_listTeamPanel
    anchors.top: exivaHunterBrinque_lblColunaEsquerda.bottom
    anchors.left: parent.left
    anchors.bottom: exivaHunterBrinque_lblManual.top
    margin-top: 6
    margin-bottom: 10
    width: 210
    vertical-scrollbar: exivaHunterBrinque_scrollTeamEx
    layout:
      type: verticalBox
      spacing: 4

  VerticalScrollBar
    id: exivaHunterBrinque_scrollTeamEx
    anchors.top: exivaHunterBrinque_lblColunaEsquerda.bottom
    anchors.bottom: exivaHunterBrinque_lblManual.top
    anchors.left: exivaHunterBrinque_listTeamPanel.right
    margin-top: 6
    margin-bottom: 10
    step: 14
    pixels-scroll: true

  Label
    id: exivaHunterBrinque_lblColunaDireita
    text: == INIMIGOS / SCAN ==
    font: verdana-11px-rounded
    color: #ff4444
    anchors.top: parent.top
    anchors.left: parent.horizontalCenter
    margin-left: 10
    margin-top: 15
    width: 220
    text-align: center

  ScrollablePanel
    id: exivaHunterBrinque_listEnemyPanel
    anchors.top: exivaHunterBrinque_lblColunaDireita.bottom
    anchors.left: parent.horizontalCenter
    anchors.bottom: exivaHunterBrinque_lblManual.top
    margin-top: 6
    margin-left: 10
    margin-bottom: 10
    width: 210
    vertical-scrollbar: exivaHunterBrinque_scrollEnemyEx
    layout:
      type: verticalBox
      spacing: 4

  VerticalScrollBar
    id: exivaHunterBrinque_scrollEnemyEx
    anchors.top: exivaHunterBrinque_lblColunaDireita.bottom
    anchors.bottom: exivaHunterBrinque_lblManual.top
    anchors.left: exivaHunterBrinque_listEnemyPanel.right
    margin-top: 6
    margin-bottom: 10
    step: 14
    pixels-scroll: true

  Label
    id: exivaHunterBrinque_lblManual
    text: Alvo Manual / Digitar Nome:
    font: verdana-11px-rounded
    anchors.bottom: exivaHunterBrinque_lblTxtTargetTag.top
    anchors.left: parent.left
    margin-bottom: 8

  TextEdit
    id: exivaHunterBrinque_manualName
    anchors.bottom: exivaHunterBrinque_lblTxtTargetTag.top
    anchors.left: exivaHunterBrinque_lblManual.right
    anchors.right: parent.right
    margin-left: 10
    margin-bottom: 6
    height: 18

  Label
    id: exivaHunterBrinque_lblTxtTargetTag
    text: Hotkey Target:
    font: verdana-11px-rounded
    color: #ffaa00
    anchors.bottom: exivaHunterBrinque_lblTxtTeamTag.top
    anchors.left: parent.left
    margin-bottom: 10
    width: 90

  Button
    id: exivaHunterBrinque_btnEditarKeyTarget
    color: #ffffff
    anchors.top: exivaHunterBrinque_lblTxtTargetTag.top
    anchors.left: exivaHunterBrinque_lblTxtTargetTag.right
    margin-top: -3
    width: 130
    height: 20

  Label
    id: exivaHunterBrinque_lblTxtTeamTag
    text: Hotkey Team:
    font: verdana-11px-rounded
    color: #ffaa00
    anchors.bottom: exivaHunterBrinque_boxMostrarBattle.top
    anchors.left: parent.left
    margin-bottom: 12
    width: 90

  Button
    id: exivaHunterBrinque_btnEditarKeyTeam
    color: #ffffff
    anchors.top: exivaHunterBrinque_lblTxtTeamTag.top
    anchors.left: exivaHunterBrinque_lblTxtTeamTag.right
    margin-top: -3
    width: 130
    height: 20

  Label
    id: exivaHunterBrinque_lblTxtCancelTag
    text: Hotkey Cancel:
    font: verdana-11px-rounded
    color: #ffaa00
    anchors.bottom: exivaHunterBrinque_lblTxtDelayTag.top
    anchors.left: parent.horizontalCenter
    margin-left: 10
    margin-bottom: 10
    width: 90

  Button
    id: exivaHunterBrinque_btnEditarKeyCancel
    color: #ffffff
    anchors.top: exivaHunterBrinque_lblTxtCancelTag.top
    anchors.left: exivaHunterBrinque_lblTxtCancelTag.right
    margin-top: -3
    width: 130
    height: 20

  Label
    id: exivaHunterBrinque_lblTxtDelayTag
    text: Delay Exiva:
    font: verdana-11px-rounded
    color: #ffaa00
    anchors.bottom: exivaHunterBrinque_boxMostrarBattle.top
    anchors.left: parent.horizontalCenter
    margin-left: 10
    margin-bottom: 12
    width: 90

  Button
    id: exivaHunterBrinque_btnEditarDelayExiva
    color: #ffffff
    anchors.top: exivaHunterBrinque_lblTxtDelayTag.top
    anchors.left: exivaHunterBrinque_lblTxtDelayTag.right
    margin-top: -3
    width: 130
    height: 20

  CheckBox
    id: exivaHunterBrinque_boxMostrarBattle
    text: Mostrar Painel Battle Transparente na tela do jogo ao dar exiva
    font: verdana-11px-rounded
    color: #55ffff
    anchors.bottom: exivaHunterBrinque_boxPainelAutoAtivo.top
    anchors.left: parent.left
    margin-bottom: 6
    width: 450
    height: 14

  CheckBox
    id: exivaHunterBrinque_boxPainelAutoAtivo
    text: Ocultar Painel Battle Transparent apos 60 segundos sem acao
    font: verdana-11px-rounded
    anchors.bottom: exivaHunterBrinque_btnLimparHistoricoGeral.top
    anchors.left: parent.left
    margin-bottom: 8
    width: 450
    height: 14

  Button
    id: exivaHunterBrinque_btnLimparHistoricoGeral
    text: Limpar Historico (Clear Lists)
    color: #ffaa00
    font: verdana-11px-rounded
    anchors.bottom: exivaHunterBrinque_closeBtn.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 6
    height: 20

  Button
    id: exivaHunterBrinque_closeBtn
    text: Fechar Config
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 22
]]

local exivaWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
exivaWindow:hide()

local designPopUpOTUI = [[
MainWindow
  id: exivaHunterBrinque_janelaModeloEditPop
  !text: tr('Editar Campo')
  size: 260 130
  anchors.centerIn: parent
  @onEscape: self:hide()

  Label
    id: exivaHunterBrinque_lblInfo
    text: Digite o novo valor:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5

  TextEdit
    id: exivaHunterBrinque_txtEntrada
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Button
    id: exivaHunterBrinque_btnConfirmar
    text: CONFIRMAR
    color: green
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 4

  Button
    id: exivaHunterBrinque_btnCancelar
    text: Cancelar
    anchors.bottom: parent.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 4
]]

local popUpWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
popUpWindow:hide()
-- =============================================================================
-- [BLOCO 3] PAINEL FLUTUANTE BATTLE E DEFINIÇÕES DA SETA DO MAPA (IDS ISOLADOS)
-- =============================================================================
local painelBattleTrasparente = setupUI([[
UIWindow
  id: exivaHunterBrinque_painelMiniBattleTransparenteExiva
  size: 160 180
  draggable: true
  phantom: false
  focusable: false
  background-color: #000000a0
  border-width: 1
  border-color: #444444bb

  Label
    id: exivaHunterBrinque_barraArrasteHeader
    text: :: EXIVA BATTLE ::
    font: verdana-9px-bold
    color: #00bfff
    background-color: #222222ff
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 13
    text-align: center

  ScrollablePanel
    id: exivaHunterBrinque_scrollInternoBattle
    anchors.top: exivaHunterBrinque_barraArrasteHeader.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: 4
    phantom: true
    layout:
      type: verticalBox
      spacing: 3
]], widgetRaizDoJogo)
painelBattleTrasparente:hide()

local scrollInternoBattle = painelBattleTrasparente.exivaHunterBrinque_scrollInternoBattle
local painelDoMapaJogo = modules.game_interface.getMapPanel()

local widgetArrow = setupUI([[
UIWidget
  height: 64
  width: 64
  anchors.centerIn: parent
  visible: false
  phantom: true
]], painelDoMapaJogo)

if g_resources.fileExists(CAMINHO_FOTO_SETA) then 
    widgetArrow:setImageSource(CAMINHO_FOTO_SETA)
else 
    local arrowItem = g_ui.createWidget('Item', widgetArrow)
    arrowItem:fill('parent')
    arrowItem:setItemId(11104)
    arrowItem:setVirtual(true)
end

local arrowPos = {
  west = {rotation=270, ml=-80, mt=0}, east = {rotation=90, ml=80, mt=0},
  north = {rotation=0, ml=0, mt=-80}, south = {rotation=180, ml=0, mt=80},
  ["north-west"] = {rotation=315, ml=-80, mt=-80}, ["north-east"] = {rotation=45, ml=80, mt=-80},
  ["south-west"] = {rotation=225, ml=-80, mt=80}, ["south-east"] = {rotation=135, ml=80, mt=80}
}

function showExivaArrow(direction)
    local pos = arrowPos[direction]
    if not pos then return end
    widgetArrow:setRotation(pos.rotation)
    widgetArrow:setMarginLeft(pos.ml)
    widgetArrow:setMarginTop(pos.mt)
    widgetArrow:setVisible(true)
    widgetArrow:raise() 
    schedule(2500, function() widgetArrow:setVisible(false) end)
end

function updateIconeVisualFidelidade()
    if botoesLateraisUI and botoesLateraisUI.btnMestreExivaOnOffSwitch then
        botoesLateraisUI.btnMestreExivaOnOffSwitch:setOn(config.macroAtiva)
        botoesLateraisUI.btnMestreExivaOnOffSwitch:setText(config.macroAtiva and "Exiva: ON" or "Exiva: OFF")
    end
end

-- =============================================================================
-- [BLOCO 4] RENDERIZADOR DAS LISTAS COORDENADO PELOS IDS EXCLUSIVOS
-- =============================================================================
function updateExivaUI()
    if not config or not exivaWindow or not painelBattleTrasparente then return end
    
    -- Vincula os novos IDs de botoes longos para atualizar os valores salvos
    exivaWindow.exivaHunterBrinque_btnEditarKeyTarget:setText(tostring(config.teclas.target):upper())
    exivaWindow.exivaHunterBrinque_btnEditarKeyTeam:setText(tostring(config.teclas.team):upper())
    exivaWindow.exivaHunterBrinque_btnEditarKeyCancel:setText(tostring(config.teclas.cancelar):upper())
    exivaWindow.exivaHunterBrinque_btnEditarDelayExiva:setText(tostring(config.delayMuted) .. "s")

    exivaWindow.exivaHunterBrinque_listTeamPanel:destroyChildren()
    exivaWindow.exivaHunterBrinque_listEnemyPanel:destroyChildren()
    scrollInternoBattle:destroyChildren()

    for _, entry in ipairs(config.teamList) do
        local box = g_ui.createWidget('CheckBox', exivaWindow.exivaHunterBrinque_listTeamPanel)
        box:setText(entry.name); box:setFont("verdana-11px-rounded"); box:setColor("#44ff44"); box:setHeight(15)
        box:setChecked(config.mode == "guild" and config.guildTarget:lower() == entry.name:lower())
        box.onClick = function() config.macroAtiva = true config.guildTarget = entry.name config.mode = "guild" timeoutPainelJanela = os.time() + 60 updateExivaUI() end
    end

    for _, entry in ipairs(config.blackList) do
        local box = g_ui.createWidget('CheckBox', exivaWindow.exivaHunterBrinque_listEnemyPanel)
        box:setText(entry.name); box:setFont("verdana-11px-rounded"); box:setColor("#ff4444"); box:setHeight(15)
        box:setChecked(config.mode == "target" and config.customTarget:lower() == entry.name:lower())
        box.onClick = function() config.macroAtiva = true config.customTarget = entry.name exivaWindow.exivaHunterBrinque_manualName:setText(entry.name) config.mode = "target" timeoutPainelJanela = os.time() + 60 updateExivaUI() end
    end

    if config.mode ~= "none" then
        local targetName = (config.mode == "target") and config.customTarget or config.guildTarget
        if targetName and targetName ~= "" and targetName:lower() ~= "nenhum" then
            local lblAlvo = g_ui.createWidget('Label', scrollInternoBattle)
            lblAlvo:setText("[ALVO] " .. targetName:upper()); lblAlvo:setFont("verdana-11px-rounded"); lblAlvo:setHeight(15)
            lblAlvo:setColor((config.mode == "target") and "#ff4444" or "#44ff44")
            local sep = g_ui.createWidget('Label', scrollInternoBattle)
            sep:setText("--------------------"); sep:setFont("verdana-11px-rounded"); sep:setColor("#555555"); sep:setHeight(10)
        end
    end

    for _, entry in ipairs(config.blackList) do
        if config.mode == "none" or entry.name:lower() ~= config.customTarget:lower() then
            local lblInimigo = g_ui.createWidget('Label', scrollInternoBattle)
            lblInimigo:setText(entry.name); lblInimigo:setFont("verdana-11px-rounded"); lblInimigo:setColor("#cccccc"); lblInimigo:setHeight(14)
        end
    end

    if config.macroAtiva and config.mode ~= "none" and config.opcoes.mostrarMiniBattle then
        painelBattleTrasparente:show()
    else
        painelBattleTrasparente:hide()
    end
    updateIconeVisualFidelidade()
end
-- =============================================================================
-- [BLOCO 5] GERENCIAMENTO DE CLIQUES E GANCHOS DO POP-UP SEGURO
-- =============================================================================
function desligarTudoCompletamente()
    config.macroAtiva = false
    config.mode = "none"
    timeoutPainelJanela = 0
    painelBattleTrasparente:hide()
    updateExivaUI()
    print(">>> [EXIVA] Todo o sistema de rastreamento foi recolhido!")
end

local function sincronizarDadosDoStorage()
    exivaWindow.exivaHunterBrinque_boxMostrarBattle:setChecked(config.opcoes.mostrarMiniBattle == true)
    exivaWindow.exivaHunterBrinque_boxPainelAutoAtivo:setChecked(config.opcoes.painelAtivo == true)
    exivaWindow.exivaHunterBrinque_manualName:setText(config.customTarget)
    exivaWindow:move(config.posicaoMestre.x, config.posicaoMestre.y)
    painelBattleTrasparente:setPosition({x = config.posicaoBattle.x, y = config.posicaoBattle.y})
    updateExivaUI()
end

function dispararAberturaPopUpSeguro(chaveStorage, nomeDoCampoNoMenu, subChaveTeclas)
    campoExivaEditandoVal = chaveStorage
    campoExivaEditandoSubVal = subChaveTeclas
    popUpWindow:setText("Editar: " .. nomeDoCampoNoMenu)
    popUpWindow.exivaHunterBrinque_lblInfo:setText("Digite o novo valor para " .. nomeDoCampoNoMenu .. ":")
    local valorAtualNaMemoria = subChaveTeclas and tostring(config.teclas[subChaveTeclas] or "") or tostring(config[chaveStorage] or "")
    popUpWindow.exivaHunterBrinque_txtEntrada:setText(valorAtualNaMemoria)
    popUpWindow:show() popUpWindow:raise() popUpWindow:focus() popUpWindow.exivaHunterBrinque_txtEntrada:focus()
end

-- Atribuição de cliques para os botões brancos abrirem o Pop-Up Seguro isolado
exivaWindow.exivaHunterBrinque_btnEditarKeyTarget.onClick = function() dispararAberturaPopUpSeguro("teclas", "Hotkey Target (Inimigo)", "target") end
exivaWindow.exivaHunterBrinque_btnEditarKeyTeam.onClick = function() dispararAberturaPopUpSeguro("teclas", "Hotkey Team (Aliado)", "team") end
exivaWindow.exivaHunterBrinque_btnEditarKeyCancel.onClick = function() dispararAberturaPopUpSeguro("teclas", "Hotkey Cancel (Desligar)", "cancelar") end
exivaWindow.exivaHunterBrinque_btnEditarDelayExiva.onClick = function() dispararAberturaPopUpSeguro("delayMuted", "Delay do Exiva Hunter", nil) end

botoesLateraisUI.btnMestreExivaOnOffSwitch.onClick = function()
    config.macroAtiva = not config.macroAtiva
    if not config.macroAtiva then desligarTudoCompletamente() else config.mode = "target" timeoutPainelJanela = os.time() + 60 updateExivaUI() end
end

botoesLateraisUI.btnSetupExiva.onClick = function() if exivaWindow:isVisible() then exivaWindow:hide() else exivaWindow:show() exivaWindow:raise() exivaWindow:focus() sincronizarDadosDoStorage() end end
exivaWindow.exivaHunterBrinque_closeBtn.onClick = function() exivaWindow:hide() end
exivaWindow.exivaHunterBrinque_boxMostrarBattle.onClick = function(w) local estado = not w:isChecked() w:setChecked(estado) config.opcoes.mostrarMiniBattle = estado updateExivaUI() end
exivaWindow.exivaHunterBrinque_boxPainelAutoAtivo.onClick = function(w) local estado = not w:isChecked() w:setChecked(estado) config.opcoes.painelAtivo = estado end
exivaWindow.onMove = function(w, oldPos, newPos) config.posicaoMestre.x = newPos.x config.posicaoMestre.y = newPos.y end
exivaWindow.exivaHunterBrinque_manualName.onTextChange = function(w, text) config.customTarget = text:trim() end

exivaWindow.exivaHunterBrinque_btnLimparHistoricoGeral.onClick = function()
    config.blackList = {} config.customTarget = "" exivaWindow.exivaHunterBrinque_manualName:setText("") config.mode = "none" painelBattleTrasparente:hide() updateExivaUI() print(">>> [EXIVA] Historico de nomes limpo manualmente via Botao Clear!") 
end

painelBattleTrasparente.onGeometryChange = function(widget, oldGeom, newGeometry) config.posicaoBattle.x = newGeometry.x config.posicaoBattle.y = newGeometry.y end

popUpWindow.exivaHunterBrinque_btnCancelar.onClick = function() popUpWindow:hide() end
popUpWindow.exivaHunterBrinque_btnConfirmar.onClick = function()
    local entradaDigitada = popUpWindow.exivaHunterBrinque_txtEntrada:getText():trim()
    if campoExivaEditandoVal ~= "" then
        if campoExivaEditandoSubVal then config.teclas[campoExivaEditandoSubVal] = entradaDigitada
        elseif campoExivaEditandoVal == "delayMuted" then config.delayMuted = tonumber(entradaDigitada) or 0.5
        else config[campoExivaEditandoVal] = entradaDigitada end
    end
    popUpWindow:hide() updateExivaUI()
end
-- =============================================================================
-- [BLOCO 6] LISTENERS DE TECLADO E MOTORES DE AGRESSÃO DE WAR (1ms)
-- =============================================================================

onKeyPress(function(keys)
    if modules.game_console:isChatEnabled() then return end
    local keyLower = keys:lower():trim()
    local tgtKey   = (config.teclas.target or ""):lower():trim()
    local teamKey  = (config.teclas.team or ""):lower():trim()
    local escKey   = (config.teclas.cancelar or ""):lower():trim()

    if keyLower == tgtKey then 
        config.macroAtiva = true config.mode = "target" timeoutPainelJanela = os.time() + 60 updateExivaUI()
    elseif keyLower == teamKey then 
        config.macroAtiva = true config.mode = "guild" timeoutPainelJanela = os.time() + 60 updateExivaUI()
    elseif keyLower == escKey then 
        desligarTudoCompletamente()
    end
end)

onTextMessage(function(mode, text)
    if not text then return end
    local txtLower = text:lower():trim()
    local d = txtLower:match("is to the ([a-z-]+)%.") or txtLower:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

-- SEU MOTOR PRINCIPAL PvP ULTRA REACTIVE INSTANTÂNEO DE 1ms
macro(1, function()
    local attackingCreature = g_game.getAttackingCreature()
    if config.opcoes.priorizarTarget and attackingCreature and attackingCreature:isPlayer() then
        local nomeAlvoAtaque = attackingCreature:getName()
        if config.customTarget:lower() ~= nomeAlvoAtaque:lower() then
            config.macroAtiva = true
            config.customTarget = nomeAlvoAtaque
            if exivaWindow then exivaWindow.exivaHunterBrinque_manualName:setText(nomeAlvoAtaque) end
            config.mode = "target"
            
            local achouNaLista = false
            for _, e in ipairs(config.blackList) do if e.name:lower() == nomeAlvoAtaque:lower() then e.time = os.time() achouNaLista = true break end end
            if not achouNaLista then table.insert(config.blackList, 1, {name = nomeAlvoAtaque, time = os.time()}) end
            
            timeoutPainelJanela = os.time() + 60
            updateExivaUI()
        end
    end

    if not config.macroAtiva or config.mode == "none" then return end

    local targetName = (config.mode == "target") and config.customTarget or config.guildTarget
    if not targetName or targetName == "" or targetName:lower() == "nenhum" then return end
    if config.mode == "target" and attackingCreature and attackingCreature:getName():lower() == targetName:lower() then return end

    if g_game and g_game.talk and os.clock() - delayExivaTimer > (config.delayMuted or 0.5) then
        g_game.talk('exiva "' .. targetName .. '"')
        delayExivaTimer = os.clock()
        if config.mode == "target" then timeoutPainelJanela = os.time() + 60 end
    end
end)

-- LOOP REATIVO DO PISCA DO TITULO COM ID TOTALMENTE ISOLADO (400ms)
macro(400, function()
    if exivaWindow and exivaWindow:isVisible() and exivaWindow.exivaHunterBrinque_waveContainer then
        local estadoAtual = exivaWindow.exivaHunterBrinque_waveContainer:isVisible()
        exivaWindow.exivaHunterBrinque_waveContainer:setVisible(not estadoAtual)
    end
end)

-- LOOP SECUNDÁRIO DE CONTATO VISUAL E VARREDURA DE ALIADOS LOUCOS
macro(1000, function()
    if not config.macroAtiva then return end
    if config.opcoes.painelAtivo and painelBattleTrasparente:isVisible() and timeoutPainelJanela > 0 then
        if os.time() >= timeoutPainelJanela then desligarTudoCompletamente() print(">>> [EXIVA] Painel Battle Transparent recolhido automaticamente.") end
    end

    local localPlayer = g_game.getLocalPlayer()
    if not localPlayer then return end
    local now = os.time()
    local mudouLista = false

    for i = #config.blackList, 1, -1 do
        if config.blackList[i] and config.blackList[i].time and (now - config.blackList[i].time > 60) then
            if config.blackList[i].name:lower() ~= config.customTarget:lower() then table.remove(config.blackList, i) mudouLista = true end
        end
    end

    for i = #config.teamList, 1, -1 do if not config.teamList[i] or not config.teamList[i].time or (now - config.teamList[i].time > 600) then table.remove(config.teamList, i) mudouLista = true end end

    for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec:getName() ~= localPlayer:getName() then
            local name = spec:getName()
            local isAlly = spec:isPartyMember() or (spec:getShield() >= 1 and spec:getShield() <= 3)
            pcall(function() if localPlayer:getEmblem() > 0 and spec:getEmblem() == localPlayer:getEmblem() then isAlly = true end end)
            if isAlly then
                local achou = false
                for _, e in ipairs(config.teamList) do if e.name == name then e.time = now; achou = true break end end
                if not achou then table.insert(config.teamList, 1, {name = name, time = now}); mudouLista = true end
            end
        end
    end
    if mudouLista or exivaWindow:isVisible() then updateExivaUI() end
end)

-- VARREDURA REAL DO RECONSTRUTOR DE RAM CONTRA JANELAS DUPLICADAS POR IDS EXCLUSIVOS
for _, child in pairs(widgetRaizDoJogo:getChildren()) do 
    if child:getId() == "exivaHunterBrinque_janelaGeralMestre" and child ~= exivaWindow then child:destroy() end 
    if child:getId() == "exivaHunterBrinque_janelaModeloEditPop" and child ~= popUpWindow then child:destroy() end
    if child:getId() == "exivaHunterBrinque_painelMiniBattleTransparenteExiva" and child ~= painelBattleTrasparente then child:destroy() end
end

exivaWindow.exivaHunterBrinque_boxMostrarBattle:setChecked(config.opcoes.mostrarMiniBattle == true)
exivaWindow.exivaHunterBrinque_boxPainelAutoAtivo:setChecked(config.opcoes.painelAtivo == true)
exivaWindow:move(config.posicaoMestre.x, config.posicaoMestre.y)
painelBattleTrasparente:setPosition({x = config.posicaoBattle.x, y = config.posicaoBattle.y})
updateExivaUI()

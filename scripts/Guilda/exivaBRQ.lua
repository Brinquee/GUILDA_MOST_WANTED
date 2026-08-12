setDefaultTab("Main")

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
        posicaoBattle = { x = 100, y = 150 } -- Memoria fisica das coordenadas do mini battle
    }
end

local config = storage[panelName]
local CAMINHO_FOTO_SETA = "/bot/CUSTOM_PREMIUM/imagens/stylesense.png"

local currentTab = "enemy"
local timeoutPainelJanela = 0
local delayExivaTimer = 0

local painelDaAbaMain = getTab("Main")
if painelDaAbaMain:recursiveGetChildById("panelBotoesExivaNativos") then
    painelDaAbaMain:recursiveGetChildById("panelBotoesExivaNativos"):destroy()
end

local botoesLateraisUI = setupUI([[
Panel
  id: panelBotoesExivaNativos
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4

  BotSwitch
    id: btnOnOffExiva
    text: Exiva: On/Off
    width: 85
    color: #44ff44

  Button
    id: btnSetupExiva
    text: Config Painel
    width: 85
    color: #00bfff
]], painelDaAbaMain)

local widgetRaizDoJogo = g_ui.getRootWidget()
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaGeralExivaHunterMestre\n" ..
"  !text: tr('Exiva Hunter Ultimate Premium')\n" ..
"  size: 500 500\n" ..
"  background-color: #1a1a1aef\n" ..
"  @onEscape: self:hide()\n" ..
"\n" ..
"  Label\n" ..
"    id: lblColunaEsquerda\n" ..
"    text: == ALIADOS / TEAM ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #44ff44\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: listTeamPanel\n" ..
"    anchors.top: lblColunaEsquerda.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.bottom: lblManual.top\n" ..
"    margin-top: 6\n" ..
"    margin-bottom: 10\n" ..
"    width: 210\n" ..
"    vertical-scrollbar: scrollTeamEx\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 4\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: scrollTeamEx\n" ..
"    anchors.top: lblColunaEsquerda.bottom\n" ..
"    anchors.bottom: lblManual.top\n" ..
"    anchors.left: listTeamPanel.right\n" ..
"    margin-top: 6\n" ..
"    margin-bottom: 10\n" ..
"    step: 14\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblColunaDireita\n" ..
"    text: == INIMIGOS / SCAN ==\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ff4444\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: listEnemyPanel\n" ..
"    anchors.top: lblColunaDireita.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.bottom: lblManual.top\n" ..
"    margin-top: 6\n" ..
"    margin-left: 10\n" ..
"    margin-bottom: 10\n" ..
"    width: 210\n" ..
"    vertical-scrollbar: scrollEnemyEx\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 4\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: scrollEnemyEx\n" ..
"    anchors.top: lblColunaDireita.bottom\n" ..
"    anchors.bottom: lblManual.top\n" ..
"    anchors.left: listEnemyPanel.right\n" ..
"    margin-top: 6\n" ..
"    margin-bottom: 10\n" ..
"    step: 14\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblManual\n" ..
"    text: Alvo Manual / Digitar Nome:\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: manualName.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-bottom: 2\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: manualName\n" ..
"    anchors.bottom: lblT1.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-bottom: 8\n" ..
"    height: 18\n" ..
"\n" ..
"  Label\n" ..
"    id: lblT1\n" ..
"    text: Hotkey Target:      Hotkey Team:      Hotkey Cancel:      Delay Exiva (Segundos):\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: txtKeyTarget.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-bottom: 3\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: txtKeyTarget\n" ..
"    anchors.bottom: boxMostrarBattle.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-bottom: 8\n" ..
"    width: 100\n" ..
"    height: 18\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: txtKeyTeam\n" ..
"    anchors.bottom: boxMostrarBattle.top\n" ..
"    anchors.left: txtKeyTarget.right\n" ..
"    margin-left: 20\n" ..
"    margin-bottom: 8\n" ..
"    width: 100\n" ..
"    height: 18\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: txtKeyCancel\n" ..
"    anchors.bottom: boxMostrarBattle.top\n" ..
"    anchors.left: txtKeyTeam.right\n" ..
"    margin-left: 20\n" ..
"    margin-bottom: 8\n" ..
"    width: 100\n" ..
"    height: 18\n" ..
"\n" ..
"  TextEdit\n" ..
"    id: txtDelayExivaSegundos\n" ..
"    anchors.bottom: boxMostrarBattle.top\n" ..
"    anchors.left: txtKeyCancel.right\n" ..
"    margin-left: 20\n" ..
"    margin-bottom: 8\n" ..
"    width: 100\n" ..
"    height: 18\n" ..
"\n" ..
"  CheckBox\n" ..
"    id: boxMostrarBattle\n" ..
"    text: Mostrar Painel Battle Transparente na tela do jogo ao dar exiva\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #55ffff\n" ..
"    anchors.bottom: boxPainelAutoAtivo.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-bottom: 6\n" ..
"    width: 450\n" ..
"    height: 14\n" ..
"\n" ..
"  CheckBox\n" ..
"    id: boxPainelAutoAtivo\n" ..
"    text: Ocultar Painel Battle Transparent apos 60 segundos sem acao\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: btnLimparHistoricoGeral.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-bottom: 8\n" ..
"    width: 450\n" ..
"    height: 14\n" ..
"\n" ..
"  Button\n" ..
"    id: btnLimparHistoricoGeral\n" ..
"    text: Limpar Historico (Clear Lists)\n" ..
"    color: #ffaa00\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.bottom: closeBtn.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-bottom: 6\n" ..
"    height: 20\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar Config\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 22\n"

local exivaWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
exivaWindow:hide()

local painelBattleTrasparente = setupUI(
"UIWindow\n" ..
"  id: painelMiniBattleTransparenteExiva\n" ..
"  size: 160 180\n" ..
"  draggable: true\n" ..
"  phantom: false\n" ..
"  focusable: false\n" ..
"  background-color: #000000a0\n" ..
"  border-width: 1\n" ..
"  border-color: #444444bb\n" ..
"\n" ..
"  Label\n" ..
"    id: barraArrasteHeader\n" ..
"    text: :: EXIVA BATTLE ::\n" ..
"    font: verdana-9px-bold\n" ..
"    color: #00bfff\n" ..
"    background-color: #222222ff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    height: 13\n" ..
"    text-align: center\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: scrollInternoBattle\n" ..
"    anchors.top: barraArrasteHeader.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    margin: 4\n" ..
"    phantom: true\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 3\n", widgetRaizDoJogo)
painelBattleTrasparente:hide()

local scrollInternoBattle = painelBattleTrasparente.scrollInternoBattle

local widgetArrow = setupUI([[
UIWidget
  height: 64
  width: 64
  anchors.centerIn: parent
  visible: false
  phantom: true
]], modules.game_interface.getMapPanel())

if g_resources.fileExists(CAMINHO_FOTO_SETA) then widgetArrow:setImageSource(CAMINHO_FOTO_SETA)
else local arrowItem = g_ui.createWidget('Item', widgetArrow) arrowItem:fill('parent') arrowItem:setItemId(11104) arrowItem:setVirtual(true) end

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

function desligarTudoCompletamente()
    config.macroAtiva = false
    config.mode = "none"
    timeoutPainelJanela = 0
    painelBattleTrasparente:hide()
    updateExivaUI()
    print(">>> [EXIVA] Todo o sistema de rastreamento foi desativado!")
end
function updateExivaUI()
    exivaWindow.listTeamPanel:destroyChildren()
    exivaWindow.listEnemyPanel:destroyChildren()
    scrollInternoBattle:destroyChildren()

    for _, entry in ipairs(config.teamList) do
        local box = g_ui.createWidget('CheckBox', exivaWindow.listTeamPanel)
        box:setText(entry.name); box:setFont("verdana-11px-rounded"); box:setColor("#44ff44"); box:setHeight(15)
        box:setChecked(config.mode == "guild" and config.guildTarget:lower() == entry.name:lower())
        box.onClick = function() config.macroAtiva = true config.guildTarget = entry.name config.mode = "guild" timeoutPainelJanela = os.time() + 60 updateExivaUI() end
    end

    for _, entry in ipairs(config.blackList) do
        local box = g_ui.createWidget('CheckBox', exivaWindow.listEnemyPanel)
        box:setText(entry.name); box:setFont("verdana-11px-rounded"); box:setColor("#ff4444"); box:setHeight(15)
        box:setChecked(config.mode == "target" and config.customTarget:lower() == entry.name:lower())
        box.onClick = function() config.macroAtiva = true config.customTarget = entry.name exivaWindow.manualName:setText(entry.name) config.mode = "target" timeoutPainelJanela = os.time() + 60 updateExivaUI() end
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
end

local function sincronizarDadosDoStorage()
    exivaWindow.boxMostrarBattle:setChecked(config.opcoes.mostrarMiniBattle == true)
    exivaWindow.boxPainelAutoAtivo:setChecked(config.opcoes.painelAtivo == true)
    exivaWindow.txtKeyTarget:setText(config.teclas.target)
    exivaWindow.txtKeyTeam:setText(config.teclas.team)
    exivaWindow.txtKeyCancel:setText(config.teclas.cancelar)
    exivaWindow.txtDelayExivaSegundos:setText(tostring(config.delayMuted))
    exivaWindow.manualName:setText(config.customTarget)
    exivaWindow:move(config.posicaoMestre.x, config.posicaoMestre.y)
    painelBattleTrasparente:setPosition({x = config.posicaoBattle.x, y = config.posicaoBattle.y})
    updateExivaUI()
end

botoesLateraisUI.btnOnOffExiva.onClick = function()
    config.macroAtiva = not config.macroAtiva
    if not config.macroAtiva then desligarTudoCompletamente() else config.mode = "target" timeoutPainelJanela = os.time() + 60 updateExivaUI() end
end

botoesLateraisUI.btnSetupExiva.onClick = function() if exivaWindow:isVisible() then exivaWindow:hide() else exivaWindow:show() exivaWindow:raise() exivaWindow:focus() sincronizarDadosDoStorage() end end
exivaWindow.closeBtn.onClick = function() exivaWindow:hide() end

exivaWindow.boxMostrarBattle.onClick = function(w)
    local estado = not w:isChecked() w:setChecked(estado) config.opcoes.mostrarMiniBattle = estado updateExivaUI()
end

exivaWindow.boxPainelAutoAtivo.onClick = function(w) local estado = not w:isChecked() w:setChecked(estado) config.opcoes.painelAtivo = estado end

exivaWindow.onMove = function(w, oldPos, newPos) 
    config.posicaoMestre.x = newPos.x 
    config.posicaoMestre.y = newPos.y 
end

exivaWindow.btnLimparHistoricoGeral.onClick = function()
    config.blackList = {} config.customTarget = "" exivaWindow.manualName:setText("") config.mode = "none" painelBattleTrasparente:hide() updateExivaUI() print(">>> [EXIVA] Historico limpo!")
end

-- FIXADO TOTAL: Escuta as alteracoes geometricas reais e grava os valores exatos de X e Y na memoria!
painelBattleTrasparente.onGeometryChange = function(widget, oldGeom, newGeometry)
    config.posicaoBattle.x = newGeometry.x
    config.posicaoBattle.y = newGeometry.y
end

onKeyPress(function(keys)
    if modules.game_console:isChatEnabled() then return end
    local keyLower = keys:lower():trim()
    local tgtKey   = exivaWindow.txtKeyTarget:getText():lower():trim()
    local teamKey  = exivaWindow.txtKeyTeam:getText():lower():trim()
    local escKey   = exivaWindow.txtKeyCancel:getText():trim():lower()

    if keyLower == tgtKey and config.customTarget ~= "" then 
        config.macroAtiva = true config.mode = "target" timeoutPainelJanela = os.time() + 60 updateExivaUI()
    elseif keyLower == teamKey and config.guildTarget ~= "" then 
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

macro(1, function()
    config.teclas.target = exivaWindow.txtKeyTarget:getText():trim()
    config.teclas.team = exivaWindow.txtKeyTeam:getText():trim()
    config.teclas.cancelar = exivaWindow.txtKeyCancel:getText():trim()
    config.customTarget = exivaWindow.manualName:getText():trim()
    config.delayMuted = tonumber(exivaWindow.txtDelayExivaSegundos:getText()) or 0.5

    local attackingCreature = g_game.getAttackingCreature()
    if config.opcoes.priorizarTarget and attackingCreature and attackingCreature:isPlayer() then
        local nomeAlvoAtaque = attackingCreature:getName()
        if config.customTarget:lower() ~= nomeAlvoAtaque:lower() then
            config.macroAtiva = true
            config.customTarget = nomeAlvoAtaque
            exivaWindow.manualName:setText(nomeAlvoAtaque)
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

    if os.clock() - delayExivaTimer > config.delayMuted then
        g_game.talk('exiva "' .. targetName .. '"')
        delayExivaTimer = os.clock()
        if config.mode == "target" then timeoutPainelJanela = os.time() + 60 end
    end
end)

macro(1000, function()
    if not config.macroAtiva then return end
    if config.opcoes.painelAtivo and painelBattleTrasparente:isVisible() and timeoutPainelJanela > 0 then
        if os.time() >= timeoutPainelJanela then desligarTudoCompletamente() print(">>> [EXIVA] Painel Battle Transparent recolhido automaticamente.") end
    end

    local localPlayer = g_game.getLocalPlayer()
    if not localPlayer then return end
    local now = os.time()
    local mudouLista = false

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
    if mudouLista and exivaWindow:isVisible() then updateExivaUI() end
end)

for _, child in pairs(widgetRaizDoJogo:getChildren()) do 
    if child:getId() == "janelaGeralExivaHunterMestre" and child ~= exivaWindow then child:destroy() end 
    if child:getId() == "painelMiniBattleTransparenteExiva" and child ~= painelBattleTrasparente then child:destroy() end
end

exivaWindow.boxMostrarBattle:setChecked(config.opcoes.mostrarMiniBattle == true)
exivaWindow.boxPainelAutoAtivo:setChecked(config.opcoes.painelAtivo == true)
exivaWindow.txtKeyTarget:setText(config.teclas.target)
exivaWindow.txtKeyTeam:setText(config.teclas.team)
exivaWindow.txtKeyCancel:setText(config.teclas.cancelar)
exivaWindow.txtDelayExivaSegundos:setText(tostring(config.delayMuted))
exivaWindow.manualName:setText(config.customTarget)
exivaWindow:move(config.posicaoMestre.x, config.posicaoMestre.y)
painelBattleTrasparente:setPosition({x = config.posicaoBattle.x, y = config.posicaoBattle.y})
updateExivaUI()

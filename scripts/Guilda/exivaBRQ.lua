setDefaultTab("GUILD")

-- [CONFIGURAÇÃO E STORAGE]
if not storage.exivaPro then storage.exivaPro = {} end
if not storage.exivaPro.teamList then storage.exivaPro.teamList = {} end
if not storage.exivaPro.blackList then storage.exivaPro.blackList = {} end
if not storage.exivaPro.customTarget then storage.exivaPro.customTarget = "" end
if not storage.exivaPro.guildTarget then storage.exivaPro.guildTarget = "" end
if not storage.exivaPro.mode then storage.exivaPro.mode = "none" end

local config = storage.exivaPro
local imgPath = "/bot/BRINQUE/imagens/stylesense.png"

-- [FUNÇÕES AUXILIARES]
local function getRainbowColor()
    local speed = 5 
    local tick = os.clock() * speed
    local hue = tick % 6
    local r, g, b
    local i = math.floor(hue)
    local f = hue - i
    local q, t = 1 - f, f
    if i == 0 then r, g, b = 1, t, 0
    elseif i == 1 then r, g, b = q, 1, 0
    elseif i == 2 then r, g, b = 0, 1, t
    elseif i == 3 then r, g, b = 0, q, 1
    elseif i == 4 then r, g, b = t, 0, 1
    else r, g, b = 1, 0, q end
    return string.format("#%02X%02X%02X", r*255, g*255, b*255)
end

-- [SISTEMA DA SETA VISUAL]
local widgetArrow = setupUI([[
UIWidget
  height: 64
  width: 64
  anchors.centerIn: parent
  visible: false
  phantom: true
]], modules.game_interface.getMapPanel())

if g_resources.fileExists(imgPath) then
    widgetArrow:setImageSource(imgPath)
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

local function showExivaArrow(direction)
    local pos = arrowPos[direction]
    if not pos then return end
    widgetArrow:setRotation(pos.rotation)
    widgetArrow:setMarginLeft(pos.ml)
    widgetArrow:setMarginTop(pos.mt)
    widgetArrow:setVisible(true)
    widgetArrow:raise() 
    schedule(2500, function() widgetArrow:setVisible(false) end)
end

-- [INTERFACE GRÁFICA]
local exivaWindow = setupUI([[
MainWindow
  size: 360 250
  !text: tr('')
  @onEscape: self:hide()

  Label
    id: titleBase
    text: EXIVA HUNTER ULTIMATE
    font: verdana-11px-rounded
    color: #FFFFFF
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    margin-top: -5

  Panel
    id: waveContainer
    anchors.top: titleBase.top
    anchors.left: titleBase.left
    height: 12
    width: 30
    clipping: true
    phantom: true
    Label
      id: titleWave
      text: EXIVA HUNTER ULTIMATE
      font: verdana-11px-rounded
      color: #FF0000
      anchors.top: parent.top
      anchors.left: parent.left
      width: 160

  Panel
    id: leftPanel
    anchors.top: titleBase.bottom
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    width: 165
    margin-top: 10
    padding: 3
    background-color: #00000060

    Label
      id: targetDisplay
      font: verdana-11px-rounded
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 18
      text-align: center
      background-color: #00000060

    Label
      id: guildTargetDisplay
      font: verdana-11px-rounded
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 18
      margin-top: 2
      text-align: center
      background-color: #00000060

    Label
      text: ALVO MANUAL:
      font: verdana-11px-rounded
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 5

    TextEdit
      id: manualName
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      margin-top: 2
      height: 20

    Label
      id: hotkeyStatus
      text: [HOME] ATIVAR TARGET
      font: verdana-11px-rounded
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 10

    Label
      id: hotkeyGuild
      text: [END] ATIVAR GUILD
      font: verdana-11px-rounded
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 3

    Label
      text: [NumLock] DESLIGAR
      font: verdana-11px-rounded
      anchors.top: prev.bottom
      anchors.left: parent.left
      margin-top: 10
      color: #FFFF00

  Panel
    id: rightPanel
    anchors.top: titleBase.bottom
    anchors.left: leftPanel.right
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-top: 5
    margin-left: 5
    background-color: #00000044
    border-width: 1
    border-color: #333333

    Button
      id: tabTeam
      text: TEAM
      anchors.top: parent.top
      anchors.left: parent.left
      width: 80
      height: 18
      margin: 2

    Button
      id: tabEnemy
      text: PK/TARGET
      anchors.top: parent.top
      anchors.left: tabTeam.right
      width: 80
      height: 18
      margin: 2

    ScrollablePanel
      id: listPanel
      anchors.top: tabTeam.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: clearLists.top
      margin: 3
      vertical-scrollbar: listScroll
      layout: verticalBox

    VerticalScrollBar
      id: listScroll
      anchors.top: listPanel.top
      anchors.bottom: listPanel.bottom
      anchors.right: parent.right
      step: 14
      pixels-scroll: true

    Button
      id: clearLists
      text: LIMPAR LISTA
      anchors.bottom: parent.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      height: 20
      margin: 3
]], g_ui.getRootWidget())
exivaWindow:hide()

-- [LÓGICA DE ATUALIZAÇÃO]
local currentTab = "enemy"

function updateExivaUI()
    exivaWindow.rightPanel.listPanel:destroyChildren()
    local listToShow = (currentTab == "team") and config.teamList or config.blackList
    local btnColor = (currentTab == "team") and "#90EE90" or "#FF4444"

    for _, entry in ipairs(listToShow) do
        local btn = g_ui.createWidget('Button', exivaWindow.rightPanel.listPanel)
        btn:setText(entry.name); btn:setHeight(18); btn:setFont("verdana-11px-rounded"); btn:setColor(btnColor)
        btn.onClick = function() 
            if currentTab == "team" then config.guildTarget = entry.name
            else config.customTarget = entry.name; exivaWindow.leftPanel.manualName:setText(entry.name) end
            updateExivaUI() 
        end
    end

    exivaWindow.rightPanel.tabTeam:setColor(currentTab == "team" and "#90EE90" or "#888888")
    exivaWindow.rightPanel.tabEnemy:setColor(currentTab == "enemy" and "#FF4444" or "#888888")
    exivaWindow.leftPanel.targetDisplay:setText("TARGET: " .. (config.customTarget ~= "" and config.customTarget:upper() or "NENHUM"))
    exivaWindow.leftPanel.targetDisplay:setColor(config.mode == "target" and "#FF0000" or "#888888")
    exivaWindow.leftPanel.guildTargetDisplay:setText("GUILD: " .. (config.guildTarget ~= "" and config.guildTarget:upper() or "NENHUM"))
    exivaWindow.leftPanel.guildTargetDisplay:setColor(config.mode == "guild" and "#90EE90" or "#888888")
    exivaWindow.leftPanel.hotkeyStatus:setColor(config.mode == "target" and "#FF0000" or "#555555")
    exivaWindow.leftPanel.hotkeyGuild:setColor(config.mode == "guild" and "#90EE90" or "#555555")
end

-- [CONTROLES E EVENTOS]
onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

onKeyPress(function(keys)
    if modules.game_console:isChatEnabled() then return end
    if keys == "Home" then config.mode = "target"; updateExivaUI()
    elseif keys == "End" then config.mode = "guild"; updateExivaUI()
    elseif keys == "NumLock" then config.mode = "none"; updateExivaUI() end
end)

-- [MACRO PRINCIPAL: AUTO-EXIVA INTELIGENTE]
macro(2000, function()
    if config.mode == "none" then return end
    
    local targetName = (config.mode == "target") and config.customTarget or config.guildTarget
    if not targetName or targetName == "" or targetName == "Nenhum" then return end

    local attacking = g_game.getAttackingCreature()
    
    if config.mode == "target" then
        if attacking and attacking:getName():lower() == targetName:lower() then
            return 
        end
    end

    if config.mode == "guild" then
        for _, spec in ipairs(getSpectators()) do
            if spec:getName():lower() == targetName:lower() then
                local dist = getDistanceBetween(player:getPosition(), spec:getPosition())
                if dist <= 7 then return end 
            end
        end
    end

    g_game.talk('exiva "' .. targetName .. '"')
end)

-- [MACRO DE SCAN E FILTRO DE TEMPO CORRIGIDO]
macro(1000, function()
    local now = os.time()
    local changed = false
    local attacking = g_game.getAttackingCreature()

    -- 1. Limpeza Segura (Trava de erro para nomes sem 'time')
    local function cleanList(list)
        for i = #list, 1, -1 do
            -- Se não tiver o campo time ou se o tempo passou de 10 min
            if not list[i].time or (now - list[i].time > 600) then 
                table.remove(list, i)
                changed = true
            end
        end
    end
    
    cleanList(config.teamList)
    cleanList(config.blackList)

    -- 2. Scan de Spectators
    for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec ~= player then
            local name = spec:getName()
            local isAlly = spec:isPartyMember() or (spec:getShield() >= 1 and spec:getShield() <= 3) or (player:getEmblem() > 0 and spec:getEmblem() == player:getEmblem())
            
            if isAlly then
                local found = false
                for _, e in ipairs(config.teamList) do if e.name == name then e.time = now; found = true break end end
                if not found then table.insert(config.teamList, 1, {name = name, time = now}); changed = true end
            else
                local isPK = spec:getSkull() > 0
                local isMyTarget = attacking and attacking == spec
                
                if isPK or isMyTarget then
                    local found = false
                    for _, e in ipairs(config.blackList) do if e.name == name then e.time = now; found = true break end end
                    if not found then table.insert(config.blackList, 1, {name = name, time = now}); changed = true end
                end
            end
        end
    end

    if changed and exivaWindow:isVisible() then updateExivaUI() end
end)

-- [ANIMAÇÕES E UI]
macro(50, function()
    if not exivaWindow:isVisible() then return end
    exivaWindow.waveContainer:setMarginLeft(((os.clock() * 1000 % 2500) / 2500 * 250) - 50)
    exivaWindow.waveContainer.titleWave:setMarginLeft(-exivaWindow.waveContainer:getMarginLeft())
    exivaWindow:setBorderColor(getRainbowColor())
end)

exivaWindow.rightPanel.tabTeam.onClick = function() currentTab = "team"; updateExivaUI() end
exivaWindow.rightPanel.tabEnemy.onClick = function() currentTab = "enemy"; updateExivaUI() end
exivaWindow.rightPanel.clearLists.onClick = function()
    if currentTab == "team" then config.teamList = {} else config.blackList = {} end
    updateExivaUI()
end
exivaWindow.leftPanel.manualName.onTextChange = function(w, text) config.customTarget = text; updateExivaUI() end

addButton("openExiva", "Exiva Hunter", function() exivaWindow:show(); exivaWindow:raise(); updateExivaUI() end)

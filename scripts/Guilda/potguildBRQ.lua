setDefaultTab("GUILD")

--[[
===================================================
PartyPot - Party Manager + Auto Potion Allies   
===================================================
]]--

-------------------------------------------------
-- 0. SEGURANÇA DO ATUALIZADOR (AUTO-OVERWRITE)
-------------------------------------------------
if meuMacroPotGuild then meuMacroPotGuild:setOff() end
if meuMacroMpRequest then meuMacroMpRequest:setOff() end

-------------------------------------------------
-- 1. STORAGE — defaults & migration
-------------------------------------------------
local panelName = "PartyPot"

if not storage[panelName] then
    storage[panelName] = {
        enabled       = false,
        leaderName    = "Leader",
        autoPartyList = {},
        onMove        = false,
        potParty  = true,
        potGuild  = false,
        potFriend = false,
        potCustom = false,
        customPotList = {},
        hpEK = 80, hpED = 80, hpMS = 80, hpRP = 80,
        hpEnabledEK = true, hpEnabledED = true, hpEnabledMS = true, hpEnabledRP = true,
        mpEK = true, mpED = true, mpMS = true, mpRP = true,
        hpItemEK = 0, hpItemED = 0, hpItemMS = 0, hpItemRP = 0,
        mpItemEK = 0, mpItemED = 0, mpItemMS = 0, mpItemRP = 0,
        mpRequestEnabled = false,
        mpRequestPercent = 50,
        mpRequestChannel = "Party",
        mpRequestKeyword = "p",
    }
end

local function ensureField(key, default)
    if storage[panelName][key] == nil then
        storage[panelName][key] = default
    end
end
ensureField("potParty",  true) ensureField("potGuild",  false) ensureField("potFriend", false)
ensureField("potCustom", false) ensureField("customPotList", {}) ensureField("onMove", false)
ensureField("hpEK", 80)  ensureField("hpED", 80) ensureField("hpMS", 80)  ensureField("hpRP", 80)
ensureField("hpEnabledEK", true) ensureField("hpEnabledED", true) ensureField("hpEnabledMS", true) ensureField("hpEnabledRP", true)
ensureField("mpEK", true) ensureField("mpED", true) ensureField("mpMS", true) ensureField("mpRP", true)
ensureField("hpItemEK", 0) ensureField("hpItemED", 0) ensureField("hpItemMS", 0) ensureField("hpItemRP", 0)
ensureField("mpItemEK", 0) ensureField("mpItemED", 0) ensureField("mpItemMS", 0) ensureField("mpItemRP", 0)
ensureField("mpRequestEnabled", false) ensureField("mpRequestPercent", 50) ensureField("mpRequestChannel", "Party") ensureField("mpRequestKeyword", "p")

local settings = storage[panelName]

-------------------------------------------------
-- 2. WIDGET DEFINITIONS (loaded once via g_ui)
-------------------------------------------------
g_ui.loadUIFromString([[
PartyPotName < Label
  background-color: alpha
  text-offset: 2 0
  focusable: true
  height: 16
  $focus:
    background-color: #00000055
  Button
    id: remove
    text: x
    anchors.right: parent.right
    margin-right: 15
    width: 15
    height: 15

PartyPotScrollBar < Panel
  height: 28
  margin-top: 3
  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 0
    maximum: 10
    step: 1

PartyPotItem < Panel
  height: 34
  margin-top: 7
  margin-left: 25
  margin-right: 25
  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter
  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

PartyPotCheckBox < BotSwitch
  height: 20
  margin-top: 5

PartyPotBox < Panel
  padding: 8
  padding-top: 22
  margin-top: 8
  margin-bottom: 8  
  image-border: 1
  layout:
    type: verticalBox
    fit-children: true

PartyPotListBlock < Panel
  height: 110
  margin-top: 3
  TextList
    id: list
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 83
    padding: 1
    vertical-scrollbar: listScrollBar
  VerticalScrollBar
    id: listScrollBar
    anchors.top: list.top
    anchors.bottom: list.bottom
    anchors.right: list.right
    step: 14
    pixels-scroll: true
  TextEdit
    id: nameEdit
    anchors.left: parent.left
    anchors.top: list.bottom
    margin-top: 5
    width: 120
  Button
    id: addBtn
    text: +
    anchors.right: parent.right
    anchors.left: nameEdit.right
    anchors.top: nameEdit.top
    margin-left: 3

PartyPotWindow < MainWindow
  text: Configuracao do PartyPot
  size: 520 480
  @onEscape: self:hide()
  Label
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    anchors.top: parent.top
    text-align: center
    text: Config da Party
  Label
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    text: Pocoes por Vocacao
  VerticalScrollBar
    id: contentScroll
    anchors.top: prev.bottom
    margin-top: 3
    anchors.right: parent.right
    anchors.bottom: separator.top
    step: 28
    pixels-scroll: true
    margin-right: -10
    margin-top: 5
    margin-bottom: 5
  ScrollablePanel
    id: content
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: separator.top
    vertical-scrollbar: contentScroll
    margin-bottom: 10
    Panel
      id: left
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.horizontalCenter
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true
    Panel
      id: right
      anchors.top: parent.top
      anchors.left: parent.horizontalCenter
      anchors.right: parent.right
      margin-top: 5
      margin-left: 10
      margin-right: 10
      layout:
        type: verticalBox
        fit-children: true
    VerticalSeparator
      anchors.top: left.top
      anchors.bottom: parent.bottom
      anchors.left: parent.horizontalCenter
      margin-top: 5
      margin-bottom: 5
  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: closeButton.top
    margin-bottom: 8
  ResizeBorder
    id: bottomResizeBorder
    anchors.fill: separator
    height: 3
    minimum: 380
    maximum: 700
    margin-left: 3
    margin-right: 3
    background: #ffffff88
  Button
    id: closeButton
    text: Fechar
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    margin-right: 5
]])
-------------------------------------------------
-- 3. INLINE PANEL (bot tab)
-------------------------------------------------
local partyPotUI = setupUI([[
Panel
  height: 38
  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    height: 18
    text: PartyPot
  Button
    id: btnSetup
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
  Button
    id: ptLeave
    text: Sair da Party
    anchors.left: parent.left
    anchors.top: prev.bottom
    width: 86
    height: 17
    margin-top: 3
    color: #ee0000
  Button
    id: ptShare
    text: Share EXP
    anchors.left: prev.right
    anchors.top: prev.top
    margin-left: 5
    height: 17
    width: 86
]], parent)

rootWidget = g_ui.getRootWidget()
local tcSwitch = partyPotUI.status
local ppWindow = UI.createWindow('PartyPotWindow', rootWidget)
ppWindow:hide()

ppWindow.closeButton.onClick = function() ppWindow:hide() end

partyPotUI.btnSetup.onClick = function()
    ppWindow:show() ppWindow:raise() ppWindow:focus()
end

partyPotUI.ptShare.onClick = function()
    g_game.partyShareExperience(not player:isPartySharedExperienceActive())
end

partyPotUI.ptLeave.onClick = function() g_game.partyLeave() end

tcSwitch:setOn(settings.enabled)
tcSwitch.onClick = function(widget)
    settings.enabled = not settings.enabled
    widget:setOn(settings.enabled)
end

local leftPanel  = ppWindow.content.left
local rightPanel = ppWindow.content.right

local addCheckBox = function(id, title, defaultValue, dest, tooltip)
    local widget = UI.createWidget('PartyPotCheckBox', dest)
    widget.onClick = function() widget:setOn(not widget:isOn()) settings[id] = widget:isOn() end
    widget:setText(title)
    if tooltip then widget:setTooltip(tooltip) end
    if settings[id] == nil then widget:setOn(defaultValue) else widget:setOn(settings[id]) end
    settings[id] = widget:isOn()
    return widget
end

local addItem = function(id, title, defaultItem, dest, tooltip)
    local widget = UI.createWidget('PartyPotItem', dest)
    widget.text:setText(title)
    if tooltip then widget.text:setTooltip(tooltip) widget.item:setTooltip(tooltip) end
    widget.item:setItemId(settings[id] or defaultItem)
    widget.item.onItemChange = function(w) settings[id] = w:getItemId() end
    settings[id] = settings[id] or defaultItem
    return widget
end

local addScrollBar = function(id, title, min, max, defaultValue, dest, tooltip)
    local widget = UI.createWidget('PartyPotScrollBar', dest)
    if tooltip then widget.text:setTooltip(tooltip) end
    widget.scroll.onValueChange = function(scroll, value)
        widget.text:setText(title .. ": " .. value .. "%")
        settings[id] = value
    end
    widget.scroll:setRange(min, max)
    if tooltip then widget.scroll:setTooltip(tooltip) end
    widget.scroll:setValue(settings[id] or defaultValue)
    widget.scroll.onValueChange(widget.scroll, widget.scroll:getValue())
    return widget
end

local addLabel = function(text, dest)
    local lbl = g_ui.createWidget('Label', dest)
    lbl:setText(text) lbl:setTextAlign(AlignCenter) lbl:setMarginTop(6)
    return lbl
end

local addSeparator = function(dest)
    local sep = g_ui.createWidget('HorizontalSeparator', dest)
    sep:setMarginTop(6) sep:setMarginBottom(6)
    return sep
end

local function createBox(title, dest)
    local box = UI.createWidget('PartyPotBox', dest)
    box:setImageSourceBase64("iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAYAAADimHc4AAADlUlEQVR42u2dzW7bOhCFzwxJWw7crd+v9xES5L2zSGDLIme6UKW6y9sCPl2cDzCcADQtDj08M/yR7HK5pLsjM/dXKQWJhMFQimOMQETA3bGRmTCz/e/t/4hAKQUAEBF7GTND7x1mhtYalt6Bh+/byjzWlZn79211bWWXZdmvx9338ma2X/uGmQEG9D7g2zUDyJ9t2to2xtjry8zf6t3K9d4BA2qpv7Vv+1wpZS3z0y7b+3atj+3KTFQzw/v7+69axP/i9fX1jz/79vaWNTP/qhLx53gpcJmBhwHwx3FWPJfMhG+iJp5PKQUeEbIEid47/DGMEk/WADT1AL0DZAayBsgMZA/Y0m9BEOHRFYYyqaVqCGISEcoDmNzvd3kAG3kAUwNqVSLGRJNx9DB0aAhicpom+OM6r3gu8zzDTR1Aw8zgVRpA4+XlBb4siyxB4uPjQ4kYPQ9QFMRjmiZ1AJNlWeDH41GWIFFKgW/7GMXzuS8LvNYqS5BotcoDmGguiEyMoTyAiZnBW2uyBLMDFmkADXeHF82GEvOAqvMB1DzgPisKog9BWpAhi7B2RZC9IDUEMV1Ai/JMho4ocdGKGJnWmvIAJhGhyTi6BsgDiB0gD+AyTZM6gMk8z8oDqFmwu46pcqOg1K4Iah5waNIAJgYd0qNyv9/hRUMQLw8YAw4lYjROp5NmQ5ksyyIN4KqwbtjETcTMNBnHdQAtypMz4ZAHUD3ApQFkDXDdrIOuAQpDeczzrCGISWZKhKka4K71AGoYmgpDqdSinXH8IUiL8jyu16s8gMk0nbQrghuGBjwkwlwd0DFVYhiva2VD6r19REFUDQrcuJqPZUH4ipiVJ6iAEj5QH8PKAhD8++Fg8l1r1EB8qt9tNeQBdhBUFEYNQbU38BzxAZuAREcoDmIwx1AF0DVAMRE7EdESJx/l8lgjTIyElYjyuN+2K4IahI7Q1kRoFucEul0t+/+87DEDvY1fnWitgay/13tf7m607udB7R2Til4AbgERmorWGMQYyE2aGiITZmvX1MTAdj/j8/EQpBefzGbfbbS8PAO1wQO8dyETvfX3OivsaM3tBaxXbVppaK1pruF6vaK1hexiFmcHcEWOg1IJWG+73+3oy3R1mhtYamalWVBaw3zPCMiEBHITUxOt7UthwMyAvN8Q61ru+Z5xvnbN7Racb3ekBkwcxyPB2Tm/vr6+oK743A47G1b2+AwW01XiuMHkcbm3r3D8UIAAAAASUVORK5CYII=")
    local titleLabel = g_ui.createWidget('Label', box)
    titleLabel:setText(title) titleLabel:setTextAlign(AlignCenter) titleLabel:setMarginTop(-20) titleLabel:setMarginBottom(8)
    return box
end
local playerBox = createBox("Config do Player", leftPanel)
addScrollBar("mpRequestPercent", "Mana", 0, 100, 50, playerBox, "Threshold de mana para pedir")
addCheckBox("mpRequestEnabled", "Pedir Mana", false, playerBox, "Pede mana automaticamente")

addLabel("Canal", playerBox)
local txtMpChannel = g_ui.createWidget('TextEdit', playerBox)
txtMpChannel:setText(settings.mpRequestChannel or "Party")
txtMpChannel.onTextChange = function(widget, text) settings.mpRequestChannel = text end

addLabel("Mensagem", playerBox)
local txtMpKeyword = g_ui.createWidget('TextEdit', playerBox)
txtMpKeyword:setText(settings.mpRequestKeyword or "p")
txtMpKeyword.onTextChange = function(widget, text) settings.mpRequestKeyword = text end

local partyBox = createBox("Config da Party", leftPanel)
addLabel("Nome do Lider", partyBox)
local txtLeader = g_ui.createWidget('TextEdit', partyBox)
txtLeader:setText(settings.leaderName or "Leader")
txtLeader.onTextChange = function(widget, text) settings.leaderName = text end

addLabel("Membros da Party", partyBox)
local partyListBlock = UI.createWidget('PartyPotListBlock', partyBox)
local lstParty       = partyListBlock.list
local playerNameEdit = partyListBlock.nameEdit
local addPlayerBtn   = partyListBlock.addBtn

local function addPartyLabel(pName)
    local label = g_ui.createWidget("PartyPotName", lstParty)
    label:setText(pName)
    label.remove.onClick = function() table.removevalue(settings.autoPartyList, label:getText()) label:destroy() end
end

if settings.autoPartyList and #settings.autoPartyList > 0 then
    for _, pName in ipairs(settings.autoPartyList) do addPartyLabel(pName) end
end

addPlayerBtn.onClick = function()
    local pn = playerNameEdit:getText()
    if pn:len() > 0 and not table.contains(settings.autoPartyList, pn, true) then
        table.insert(settings.autoPartyList, pn) addPartyLabel(pn) playerNameEdit:setText('')
    end
end
playerNameEdit.onKeyPress = function(self, keyCode) if keyCode ~= 5 then return false end addPlayerBtn.onClick() return true end

local potBox = createBox("Quem Potar", leftPanel)
addCheckBox("potParty",  "Membros da Party", true, potBox)
addCheckBox("potGuild",  "Membros da Guild", false, potBox)
addCheckBox("potFriend", "Amigos (FriendList)", false, potBox)

local vocations = {"EK", "ED", "MS", "RP"}
for i, voc in ipairs(vocations) do
    local vocBox = createBox(voc, rightPanel)
    addItem("hpItem" .. voc, "Pocao de HP", 0, vocBox)
    addItem("mpItem" .. voc, "Pocao de MP", 0, vocBox)
    addScrollBar("hp" .. voc, "HP " .. voc, 0, 100, 80, vocBox)
    addCheckBox("hpEnabled" .. voc, "Ativar HP", true, vocBox)
    addCheckBox("mp" .. voc, "Ativar MP", true, vocBox)
end

local function getVoc(creature)
    if not creature then return nil end
    local txt = creature:getText()
    if not txt or txt == "" then return nil end
    if txt:find("EK") then return "EK" elseif txt:find("ED") then return "ED" elseif txt:find("MS") then return "MS" elseif txt:find("RP") then return "RP" end
    return nil
end

function isFriend2(c)
    if not storage.playerList then return false end
    local name = type(c) ~= "string" and c:getName() or c
    return table.find(storage.playerList.friendList, name) and true or false
end

local function shouldPotCreature(spec)
    if not spec or not spec:isPlayer() or spec == player then return false end
    local name = spec:getName()
    if settings.potParty and spec:isPartyMember() then return true end
    if settings.potGuild and spec:getEmblem() == 1 then return true end
    if settings.potFriend and isFriend2(name) then return true end
    if settings.potParty and table.contains(settings.autoPartyList, name, true) then return true end
    return false
end

meuMacroPotGuild = macro(300, function()
    if not settings.enabled then return end
    for _, spec in ipairs(getSpectators()) do
        if spec:isPlayer() and spec ~= player and shouldPotCreature(spec) then
            local voc = getVoc(spec)
            if voc then
                local hpEnabled = settings["hpEnabled" .. voc]
                local hpThreshold = settings["hp" .. voc]
                local hpItemId = settings["hpItem" .. voc]
                local hp = spec:getHealthPercent()
                if hpEnabled and hp and hpThreshold and hp <= hpThreshold and hpItemId > 0 then
                    usewith(hpItemId, spec) return                
                end
            end
        end
    end
end)

onTalk(function(senderName, level, mode, text)
    if not settings.enabled or text:lower() ~= "p" or senderName == player:getName() then return end
    local spec = getCreatureByName(senderName, true)
    if spec and shouldPotCreature(spec) then
        local voc = getVoc(spec)
        if voc and settings["mp" .. voc] and settings["mpItem" .. voc] > 0 then      
            usewith(settings["mpItem" .. voc], spec)
        end
    end
end)

onTextMessage(function(mode, text)
    if not tcSwitch:isOn() then return end
    if mode == 20 then
        if text:find("has joined the party") then
            local data = regexMatch(text, "([a-z A-Z-]*) has joined the party")
            if data and data and data then
                if table.contains(settings.autoPartyList, data, true) then
                    if not player:isPartySharedExperienceActive() then g_game.partyShareExperience(true) end
                end
            end
        elseif text:find("has invited you") and player:getName():lower() ~= settings.leaderName:lower() then
            local data = regexMatch(text, "([a-z A-Z-]*) has invited you")
            if data and data and data then
                if settings.leaderName:lower() == data:lower() then
                    local leader = getCreatureByName(data, true)
                    if leader then g_game.partyJoin(leader:getId()) end
                end
            end
        end
    end
end)

function ppCreatureInvites(creature)
    if not creature:isPlayer() or creature == player then return end
    if creature:getName():lower() == settings.leaderName:lower() and creature:getShield() == 1 then
        g_game.partyJoin(creature:getId()) return
    end
    if player:getName():lower() ~= settings.leaderName:lower() or not table.contains(settings.autoPartyList, creature:getName(), true) then return end
    if creature:isPartyMember() or creature:getShield() == 2 then return end
    g_game.partyInvite(creature:getId())
end

onCreatureAppear(function(creature) if tcSwitch:isOn() then ppCreatureInvites(creature) end end)

meuMacroMpRequest = macro(1500, function()
    if not settings.enabled or not settings.mpRequestEnabled then return end
    if manapercent() <= settings.mpRequestPercent then
        local partyChannel = getChannelId(settings.mpRequestChannel or "Party")
        if partyChannel then sayChannel(partyChannel, settings.mpRequestKeyword or "p") end
    end
end)

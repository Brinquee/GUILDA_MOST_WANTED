setDefaultTab("hp")

local panelName = "autoItemHP"
local ui = setupUI([[
Panel
  height: 50
  
  BotItem
    id: item
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: item.right
    anchors.bottom: item.verticalCenter
    text-align: center
    !text: tr('blessed HP')
    margin-left: 2
    width: 90
  
  BotLabel
    id: help
    anchors.top: parent.top
    anchors.left: title.right
    anchors.right: parent.right
    anchors.bottom: item.verticalCenter
    text-align: center
    margin-left: 2

  HorizontalScrollBar
    id: HP
    anchors.top: item.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    minimum: 1
    maximum: 100
    step: 1
    
]], parent)
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {
      id = 9086,
      enabled = false,
      hp = 50
  }
end

ui.title:setOn(storage[panelName].enabled)
ui.title.onClick = function(widget)
  storage[panelName].enabled = not storage[panelName].enabled
  widget:setOn(storage[panelName].enabled)
end

local updateHpText = function()
    ui.help:setText("If HP < " .. storage[panelName].hp .. "%")
end
updateHpText()

ui.HP.onValueChange = function(scroll, value)
  storage[panelName].hp = value
  updateHpText()
end

ui.item:setItemId(storage[panelName].id)
ui.item.onItemChange = function(widget)
  storage[panelName].id = widget:getItemId()
end
ui.HP:setValue(storage[panelName].hp)

macro(200, function()
  if not storage[panelName].enabled or not player then return end
  
  if player:getHealthPercent() <= storage[panelName].hp then
      useWith(storage[panelName].id, player)
  end
end)

addSeparator()
local panelName = "autoItemMP"
local ui = setupUI([[
Panel
  height: 50
  
  BotItem
    id: item
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 2
    
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: item.right
    anchors.bottom: item.verticalCenter
    text-align: center
    !text: tr('blessed MP')
    margin-left: 2
    width: 90
  
  BotLabel
    id: help
    anchors.top: parent.top
    anchors.left: title.right
    anchors.right: parent.right
    anchors.bottom: item.verticalCenter
    text-align: center
    margin-left: 2

  HorizontalScrollBar
    id: MP
    anchors.top: item.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 3
    minimum: 1
    maximum: 100
    step: 1
    
]], parent)
ui:setId(panelName)

if not storage[panelName] then
  storage[panelName] = {
      id = 9086,
      enabled = false,
      mp = 40
  }
end

ui.title:setOn(storage[panelName].enabled)
ui.title.onClick = function(widget)
  storage[panelName].enabled = not storage[panelName].enabled
  widget:setOn(storage[panelName].enabled)
end

local updateMpText = function()
    ui.help:setText("If MP < " .. storage[panelName].mp .. "%")
end
updateMpText()

ui.MP.onValueChange = function(scroll, value)
  storage[panelName].mp = value
  updateMpText()
end

ui.item:setItemId(storage[panelName].id)
ui.item.onItemChange = function(widget)
  storage[panelName].id = widget:getItemId()
end
ui.MP:setValue(storage[panelName].mp)

macro(200, function()
  if not storage[panelName].enabled or not player then return end
  
  if player:getManaPercent() <= storage[panelName].mp then
      useWith(storage[panelName].id, player)
  end
end)

addSeparator()

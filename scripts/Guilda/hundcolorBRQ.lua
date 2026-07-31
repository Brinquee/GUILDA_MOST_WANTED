setDefaultTab("TOOLS")

local panelName = "hudColors"

if type(storage[panelName]) ~= "table" then
  storage[panelName] = {
    enabled = true,
    lists = {
      {name = "Coins", color = "green" , table = { 3031, 3035,16128, 3043 }},
      {name = "Tools", color = "blue", table = { 5710, 646,3456 }},
      {name = "Backpacks", color = "white", table = { 2854 }},
    }
  }
end

local config = storage[panelName]
if config.enabled == nil then
  config.enabled = true
end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t) do
    if type(entry) == "number" then
      table.insert(r, entry)
    elseif type(entry) == "table" and entry.id then
      table.insert(r, entry.id)
    elseif type(entry) == "table" and entry.getItemId then
      table.insert(r, entry:getItemId())
    end
  end
  return r
end

local function normalizeLists()
  for _, list in pairs(config.lists) do
    list.enabled = list.enabled ~= false
    list.table = properTable(list.table or {})
  end
end

normalizeLists()

g_ui.loadUIFromString([[
ColorPaletteBox < UIWidget
  size: 16 16
  margin: 1
  border-width: 1
  border-color: #000000
  phantom: false

  $hover:
    border-color: #ffffff

HudColorPaletteWindow < MainWindow
  !text: tr('Select Color')
  size: 255 195
  draggable: true
  @onEscape: self:hide()

  Panel
    id: grid
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 130
    layout:
      type: grid
      cell-size: 16 16
      flow: true

  Button
    id: closeBtn
    text: Close
    anchors.bottom: parent.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    width: 80
    height: 20

HudColorRow < FlatPanel
  height: 85
  margin-bottom: 4
  padding: 6

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.top: parent.top
    width: 18
    height: 18
    tooltip: Enable this HUD colour list.

  TextEdit
    id: nameEdit
    anchors.left: enabled.right
    anchors.top: parent.top
    margin-left: 4
    width: 135

  TextEdit
    id: colorEdit
    anchors.left: nameEdit.right
    anchors.top: parent.top
    margin-left: 5
    width: 95

  Button
    id: colorPickerBtn
    text: P
    anchors.left: colorEdit.right
    anchors.top: colorEdit.top
    margin-left: 3
    size: 18 18
    tooltip: Open Color Palette

  Label
    id: colorPreview
    anchors.left: colorPickerBtn.right
    anchors.top: colorEdit.top
    margin-left: 5
    size: 18 18
    text-align: center
    background-color: white
    border-width: 1
    border-color: black

  Button
    id: remove
    text: X
    anchors.right: parent.right
    anchors.top: parent.top
    size: 22 18
    color: red
    tooltip: Remove this list.

  BotContainer
    id: items
    anchors.left: nameEdit.left
    anchors.right: parent.right
    anchors.top: nameEdit.bottom
    margin-top: 6
    height: 45
    cell-size: 34 34

HudColorSetupWindow < MainWindow
  !text: tr('Hud Colours')
  size: 450 400
  draggable: true
  @onEscape: self:hide()

  Label
    id: titleName
    anchors.left: parent.left
    anchors.top: parent.top
    text: Name:
    width: 135
    margin-left: 26

  Label
    id: titleColor
    anchors.left: titleName.right
    anchors.top: parent.top
    text: Colour:
    width: 95
    margin-left: 5

  ScrollablePanel
    id: list
    anchors.left: parent.left
    anchors.right: listScrollBar.left
    anchors.top: titleName.bottom
    anchors.bottom: separator.top
    margin-top: 4
    margin-bottom: 8
    vertical-scrollbar: listScrollBar
    layout:
      type: verticalBox

  VerticalScrollBar
    id: listScrollBar
    anchors.right: parent.right
    anchors.top: titleName.bottom
    anchors.bottom: separator.top
    step: 14
    pixels-scroll: true
    opacity: 0.5

  HorizontalSeparator
    id: separator
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: addButton.top
    margin-bottom: 8

  Button
    id: addButton
    text: Add
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    width: 70

  Button
    id: closeButton
    text: Close
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    width: 70
]])

local setHudFrames = function() end
UI.Separator()
local ui = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('HudFrames')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]])

ui.title:setOn(config.enabled)
ui.title.onClick = function(widget)
  config.enabled = not config.enabled
  widget:setOn(config.enabled)
  setHudFrames()
end

local setupWindow
local loadingSetup = false
local paletteWindow = nil

-- LISTA COMPLETA DE CORES VIVAS, PASTÉIS E ESCURAS DE RPG
local paletteColors = {
  "#ff0000", "#ff4500", "#ff8c00", "#ffa500", "#ffd700", "#ffff00", "#ccff00", "#80ff00", "#00ff00", "#00ff7f", "#00ffff", "#00bfff", "#0000ff",
  "#8b0000", "#b22222", "#cd5c5c", "#ff7f50", "#ff8000", "#e6bc22", "#d4af37", "#9acd32", "#556b2f", "#228b22", "#006400", "#124e3f", "#008b8b",
  "#00008b", "#1e90ff", "#4682b4", "#87ceeb", "#4b0082", "#8a2be2", "#9400d3", "#9932cc", "#ba55d3", "#ff00ff", "#ff1493", "#ff69b4", "#ee82ee",
  "#4169e1", "#5f9ea0", "#20b2aa", "#7fffd4", "#483d8b", "#6a5acd", "#7b68ee", "#da70d6", "#c71585", "#db7093", "#ffb6c1", "#ffc0cb", "#fa8072",
  "#8b4513", "#a0522d", "#cd853f", "#f4a460", "#d2b48c", "#ffe4e1", "#f5f5dc", "#faf0e6", "#e6cc80", "#b8860b", "#bc8f8f", "#d8bfd8", "#b0c4de",
  "#ffffff", "#f0f0f0", "#e0e0e0", "#d0d0d0", "#b0b0b0", "#909090", "#808080", "#707070", "#505050", "#303030", "#202020", "#101010", "#050505"
}

local function updatePreview(row, color)
  local ok = pcall(function()
    row.colorPreview:setBackgroundColor(color)
  end)
  if ok then
    row.colorPreview:setText("")
    row.colorPreview:setBorderColor("black")
  else
    row.colorPreview:setBackgroundColor("#151515")
    row.colorPreview:setBorderColor("#ff555588")
    row.colorPreview:setText("x")
    row.colorPreview:setColor("#ff9999")
  end
  return ok
end

local function addHudRow(list)
  list.table = properTable(list.table or {})

  local row = UI.createWidget("HudColorRow", setupWindow.list)
  row.enabled:setChecked(list.enabled)
  row.nameEdit:setText(list.name or "")
  row.colorEdit:setText(list.color or "")

  local ready = false
  UI.Container(function(widget, items)
    if loadingSetup or not ready then return end
    list.table = properTable(items)
    setHudFrames()
  end, true, nil, row.items)
  row.items:setItems(properTable(list.table))
  schedule(1, function()
    ready = true
  end)

  row.enabled.onClick = function(widget)
    list.enabled = not list.enabled
    widget:setChecked(list.enabled)
    setHudFrames()
  end

  row.nameEdit.onTextChange = function(widget, text)
    text = text:trim()
    if text:len() > 0 then
      list.name = text
    end
  end

  local function checkColour()
    local color = row.colorEdit:getText():trim()
    if updatePreview(row, color) then
      list.color = color
      if not loadingSetup then
        setHudFrames()
      end
    end
  end

  row.colorEdit.onTextChange = checkColour
  checkColour()

  -- AQUI ABRE A PALETA AO CLICAR NO 'P'
  row.colorPickerBtn.onClick = function()
    if paletteWindow then paletteWindow:destroy() end

    paletteWindow = UI.createWindow("HudColorPaletteWindow", g_ui.getRootWidget())
    paletteWindow.closeBtn.onClick = function() paletteWindow:destroy() end

    for _, colorHex in ipairs(paletteColors) do
      local box = UI.createWidget("ColorPaletteBox", paletteWindow.grid)
      box:setBackgroundColor(colorHex)
      
      box.onMouseRelease = function()
        row.colorEdit:setText(colorHex)
        paletteWindow:destroy()
      end
    end
  end

  row.remove.onClick = function()
    UI.ConfirmationWindow("Remove Hud Colour", "Remove " .. tostring(list.name) .. "?", function()
      local index = table.find(config.lists, list)
      if index then
        table.remove(config.lists, index)
      end
      row:destroy()
      setHudFrames()
    end)
  end
end

ui.edit.onClick = function()
  if setupWindow then
    setupWindow:show()
    setupWindow:raise()
    setupWindow:focus()
    return
  end

  setupWindow = UI.createWindow("HudColorSetupWindow", g_ui.getRootWidget())
  setupWindow.closeButton.onClick = function()
    setupWindow:hide()
    if paletteWindow then paletteWindow:destroy() end
  end
  setupWindow.addButton.onClick = function()
    local list = {enabled = true, name = "New", color = "white", table = {}}
    table.insert(config.lists, list)
    addHudRow(list)
    normalizeLists()
    setHudFrames()
  end

  loadingSetup = true
  for _, list in ipairs(config.lists) do
    addHudRow(list)
  end
  loadingSetup = false
end

local function getHudColor(id)
  for _, list in pairs(config.lists) do
    if list.enabled and table.contains(list.table, id) then
      return list.color
    end
  end
end

local function resetItemFrame(child)
  child:setImageColor("white")
  child:setImageSource("/images/ui/item")
end

setHudFrames = function()
  if not config.enabled then return end
  for _, container in pairs(getContainers()) do
    local window = container.itemsPanel
    for _, child in pairs(window:getChildren()) do
      local id = child:getItemId()
      if id == 0 then
        resetItemFrame(child)
      else
        local color = getHudColor(id)
        local ok = color and pcall(function()
          child:setImageColor(color)
        end)
        if ok then
          child:setImageSource("/images/ui/rarity_white")
        else
          resetItemFrame(child)
        end
      end
    end
  end
end

onContainerOpen(function(container, previousContainer)
  setHudFrames()
end)

onAddItem(function(container, slot, item, oldItem)
  setHudFrames()
end)

onRemoveItem(function(container, slot, item)
  setHudFrames()
end)onContainerUpdateItem(function(container, slot, item, oldItem)setHudFrames()end)setHudFrames()

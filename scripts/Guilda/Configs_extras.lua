setDefaultTab("GUILD")

local warPanelName = "warVisualConfigFinal" -- Reset completo para aplicar a lógica real

-- Inicializa o armazenamento com os alinhamentos corretos de cada escudo
if type(storage[warPanelName]) ~= "table" then
  storage[warPanelName] = {
    allies =    { enabled = true, color = "#00bfff", outfit = 1752, addon = true },  -- Escudo Azul
    guild =     { enabled = true, color = "#00ff00", outfit = 0,    addon = false }, -- Escudo Verde
    enemies =   { enabled = true, color = "#ff0000", outfit = 0,    addon = false }, -- Escudo Vermelho
    neutrals =  { enabled = true, color = "#ffffff", outfit = 0,    addon = false }  -- Sem Escudo
  }
end

local warConfig = storage[warPanelName]

-- ESTRUTURA VISUAL CONFIGURADA E ESPAÇADA
g_ui.loadUIFromString([[
WarColorPaletteBox < UIWidget
  size: 16 16
  margin: 1
  border-width: 1
  border-color: #000000
  phantom: false
  $hover:
    border-color: #ffffff

WarPaletteWindow < MainWindow
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

WarSetupRow < FlatPanel
  height: 35
  margin-bottom: 4
  padding: 5

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 18
    height: 18

  Label
    id: groupLabel
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    width: 115
    font: sans-bold-12

  TextEdit
    id: colorEdit
    anchors.left: groupLabel.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 85

  Button
    id: colorPickerBtn
    text: P
    anchors.left: colorEdit.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    size: 18 18

  Label
    id: colorPreview
    anchors.left: colorPickerBtn.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    size: 18 18
    background-color: white
    border-width: 1
    border-color: black

  Label
    id: skinLabel
    text: Skin:
    anchors.left: colorPreview.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 15
    width: 30

  TextEdit
    id: outfitEdit
    anchors.left: skinLabel.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 45

  CheckBox
    id: addonCheck
    anchors.left: outfitEdit.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 15
    width: 14
    height: 14

  Label
    id: addonLabel
    text: Addon
    anchors.left: addonCheck.right
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    font: sans-bold-10

WarSetupWindow < MainWindow
  !text: tr('War Visual Config')
  size: 530 270
  draggable: true
  @onEscape: self:hide()

  ScrollablePanel
    id: list
    anchors.fill: parent
    anchors.bottom: separator.top
    margin-bottom: 5
    layout:
      type: verticalBox

  HorizontalSeparator
    id: separator
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    text: Close
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    width: 90
]])

-- Cria o botão principal do Macro no BotPanel
UI.Separator()
local warUi = setupUI([[
Panel
  height: 19

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('War Visuals')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup
]])

local warMasterSwitch = true
warUi.title:setOn(warMasterSwitch)
warUi.title.onClick = function(widget)
  warMasterSwitch = not warMasterSwitch
  widget:setOn(warMasterSwitch)
end

local warSetupWindow = nil
local warPaletteWindow = nil

local paletteColors = {
  "#ff0000", "#ff4500", "#ff8c00", "#ffa500", "#ffd700", "#ffff00", "#ccff00", "#80ff00", "#00ff00", "#00ff7f", "#00ffff", "#00bfff", "#0000ff",
  "#8b0000", "#b22222", "#cd5c5c", "#ff7f50", "#ff8000", "#e6bc22", "#d4af37", "#9acd32", "#556b2f", "#228b22", "#006400", "#124e3f", "#008b8b",
  "#00008b", "#1e90ff", "#4682b4", "#87ceeb", "#4b0082", "#8a2be2", "#9400d3", "#9932cc", "#ba55d3", "#ff00ff", "#ff1493", "#ff69b4", "#ee82ee",
  "#4169e1", "#5f9ea0", "#20b2aa", "#7fffd4", "#483d8b", "#6a5acd", "#7b68ee", "#da70d6", "#c71585", "#db7093", "#ffb6c1", "#ffc0cb", "#fa8072",
  "#8b4513", "#a0522d", "#cd853f", "#f4a460", "#d2b48c", "#ffe4e1", "#f5f5dc", "#faf0e6", "#e6cc80", "#b8860b", "#bc8f8f", "#d8bfd8", "#b0c4de",
  "#ffffff", "#f0f0f0", "#e0e0e0", "#d0d0d0", "#b0b0b0", "#909090", "#808080", "#707070", "#505050", "#303030", "#202020", "#101010", "#050505"
}

local function updateWarRowPreview(row, color)
  return pcall(function() row.colorPreview:setBackgroundColor(color) end)
end

local function addWarConfigRow(idName, displayName, configData)
  if configData.addon == nil then configData.addon = false end

  local row = UI.createWidget("WarSetupRow", warSetupWindow.list)
  row.groupLabel:setText(displayName)
  row.enabled:setChecked(configData.enabled)
  row.colorEdit:setText(configData.color)
  row.outfitEdit:setText(tostring(configData.outfit))
  row.addonCheck:setChecked(configData.addon)

  updateWarRowPreview(row, configData.color)

  row.enabled.onClick = function(widget)
    configData.enabled = not configData.enabled
    widget:setChecked(configData.enabled)
  end

  row.addonCheck.onClick = function(widget)
    configData.addon = not configData.addon
    widget:setChecked(configData.addon)
  end

  row.colorEdit.onTextChange = function(widget, text)
    text = text:trim()
    if text:len() > 0 then
      configData.color = text
      updateWarRowPreview(row, text)
    end
  end

  row.outfitEdit.onTextChange = function(widget, text)
    local num = tonumber(text:trim())
    if num then
      configData.outfit = num
    end
  end

  row.colorPickerBtn.onClick = function()
    if warPaletteWindow then warPaletteWindow:destroy() end

    warPaletteWindow = UI.createWindow("WarPaletteWindow", g_ui.getRootWidget())
    warPaletteWindow.closeBtn.onClick = function() warPaletteWindow:destroy() end

    for _, colorHex in ipairs(paletteColors) do
      local box = UI.createWidget("WarColorPaletteBox", warPaletteWindow.grid)
      box:setBackgroundColor(colorHex)
      box.onMouseRelease = function()
        row.colorEdit:setText(colorHex)
        warPaletteWindow:destroy()
      end
    end
  end
end

warUi.edit.onClick = function()
  if warSetupWindow then
    warSetupWindow:show()
    warSetupWindow:raise()
    warSetupWindow:focus()
    return
  end

  warSetupWindow = UI.createWindow("WarSetupWindow", g_ui.getRootWidget())
  warSetupWindow.closeButton.onClick = function()
    warSetupWindow:hide()
    if warPaletteWindow then warPaletteWindow:destroy() end
  end

  addWarConfigRow("allies", "Escudo Vermelho:", warConfig.allies)
  addWarConfigRow("guild", "Escudo Verde:", warConfig.guild)
  addWarConfigRow("enemies", "Escudo Azul:", warConfig.enemies)
  addWarConfigRow("neutrals", "Sem Escudo:", warConfig.neutrals)
end

-- NOVA LÓGICA DE CHECAGEM DO EMBLEMA DO SERVIDOR
local function applyWarVisuals(creature)
  if not creature or not creature:isPlayer() or creature:isLocalPlayer() then return end

  if not warMasterSwitch then
    creature:setInformationColor('#00cc00')
    return
  end

  local emblem = creature:getEmblem()
  local cfg = nil

  -- LEITURA DINÂMICA COMPATÍVEL COM TODOS OS ENGENHOS DO TIBIA / OTC
  if emblem == 1 or emblem == 11 then
    cfg = warConfig.guild     -- Escudo Verde real (Sua Guilda)
  elseif emblem == 2 or emblem == 12 then
    cfg = warConfig.allies    -- Escudo Azul real (Seus Aliados)
  elseif emblem == 3 or emblem == 4 or emblem == 13 or emblem == 14 then
    cfg = warConfig.enemies   -- Escudo Vermelho real (Seus Inimigos de War)
  elseif emblem == 0 then
    cfg = warConfig.neutrals  -- Jogadores Sem Escudo algum
  end

  if cfg then
    if cfg.enabled then
      pcall(function() creature:setInformationColor(cfg.color) end)
      if cfg.outfit > 0 then
        local outfitTable = { type = cfg.outfit, addons = (cfg.addon and 3 or 0) }
        pcall(function() creature:setOutfit(outfitTable) end)
      end
    else
      creature:setInformationColor('#00cc00')
    end
  end
end

onCreatureAppear(function(creature)
  applyWarVisuals(creature)
end)

macro(500, function()
  if not warMasterSwitch then return end
  for _, creature in ipairs(getSpectators()) do
    if creature:isPlayer() and not creature:isLocalPlayer() then
      applyWarVisuals(creature)
    end
  end
end)

local sprh = macro(100, ".: ESCONDER SPRITE :.", function() end)
onAddThing(function(tile, thing)
  if sprh:isOff() then return end
  if thing:isEffect() then
    thing:hide()
  end
end)

-- ==========================================
-- Healing Ultimate FULL OTCv8 / vBot 4.8
-- Sync botão <-> icon + Profiles + Setup
-- ICONS DRAG + SAVE POSITION
-- ==========================================
setDefaultTab("HP")

storage.healing_master   = storage.healing_master or false
storage.potions_enabled  = storage.potions_enabled or false
storage.iconSpellPos     = storage.iconSpellPos or {x=200,y=120}
storage.iconPotPos       = storage.iconPotPos or {x=260,y=120}

UI.Separator():setColor("#FFD700")

-- =========================
-- TITLE
-- =========================
local topUI = setupUI([[
Panel
  height: 20
  background-color: #00000088

  Label
    id: title
    anchors.fill: parent
    text-align: center
    font: verdana-11px-rounded
    text: >> Healing Ultimate <<
]], parent)

local rainbow = {
"#FF0000","#FF8000","#FFFF00","#00FF00",
"#00FFFF","#0000FF","#8000FF","#FF00FF"
}

local r = 1
macro(100,function()
  if topUI and topUI.title then
    topUI.title:setColor(rainbow[r])
    r = r + 1
    if r > #rainbow then r = 1 end
  end
end)

-- =========================
-- MAIN UI
-- =========================
local ui = setupUI([[
Panel
  height: 82
  margin-top: 2

  BotSwitch
    id: spellSwitch
    anchors.top: parent.top
    anchors.left: parent.left
    width: 64
    !text: tr('Spell')

  BotSwitch
    id: potSwitch
    anchors.top: parent.top
    anchors.left: prev.right
    margin-left: 2
    width: 64
    !text: tr('Potion')

  Button
    id: settings
    anchors.top: parent.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 3
    height: 17
    text: Setup

  Panel
    id: profileButtons
    anchors.top: spellSwitch.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 18
    layout:
      type: horizontalBox
      spacing: 4

    Button
      id: EK
      text: EK
      width: 30

    Button
      id: RP
      text: RP
      width: 30

    Button
      id: ED
      text: ED
      width: 30

    Button
      id: MS
      text: MS
      width: 30
]], parent)

-- =========================
-- SETUP PANEL
-- =========================
local setup = setupUI([[
Panel
  id: setupWindow
  height: 250
  background-color: #1a1a1acc
  border: 1 black
  padding: 5
  margin-top: 3

  ScrollablePanel
    id: container
    anchors.fill: parent
    vertical-scrollbar: scrollBar
    layout:
      type: verticalBox
      spacing: 5

  VerticalScrollBar
    id: scrollBar
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    width: 8
]], parent)

setup:hide()

-- =========================
-- STORAGE
-- =========================
storage.healProfiles = storage.healProfiles or {
current = "EK",

EK = {
h1={on=true,title="High",text="exura ico",min=70,max=90},
h2={on=true,title="Low", text="exura med ico",min=0,max=69}
},

RP = {
h1={on=true,title="High",text="exura san",min=60,max=90},
h2={on=true,title="Low", text="exura gran san",min=0,max=59}
},

ED = {
h1={on=true,title="High",text="exura",min=80,max=95},
h2={on=true,title="Low", text="exura gran res",min=0,max=79}
},

MS = {
h1={on=true,title="High",text="exura",min=70,max=95},
h2={on=true,title="Low", text="exura vita",min=0,max=69}
}
}

storage.potProfiles = storage.potProfiles or {
current = "EK",

EK = {
{on=true,title="HP",item=266,min=0,max=80,type="hp"},
{on=true,title="MP",item=268,min=0,max=100,type="mp"}
},

RP = {
{on=true,title="HP",item=266,min=0,max=80,type="hp"},
{on=true,title="MP",item=268,min=0,max=100,type="mp"}
},

ED = {
{on=true,title="HP",item=266,min=0,max=100,type="hp"},
{on=true,title="MP",item=268,min=0,max=100,type="mp"}
},

MS = {
{on=true,title="HP",item=266,min=0,max=100,type="hp"},
{on=true,title="MP",item=268,min=0,max=100,type="mp"}
}
}

-- =========================
-- FUNCTIONS
-- =========================
local function getPlayer()
  return g_game.getLocalPlayer()
end

local function refreshSetup()
  setup.container:destroyChildren()

  local cur = storage.healProfiles.current
  local spell = storage.healProfiles[cur]
  local pot   = storage.potProfiles[cur]

  if UI.DualScrollPanel then
    for _,cfg in ipairs({spell.h1, spell.h2}) do
      UI.DualScrollPanel(cfg,function(widget,new)
        for k,v in pairs(new) do cfg[k]=v end
      end,setup.container)
    end
  end

  if UI.DualScrollItemPanel then
    for _,cfg in ipairs(pot) do
      UI.DualScrollItemPanel(cfg,function(widget,new)
        for k,v in pairs(new) do cfg[k]=v end
      end,setup.container)
    end
  end
end

local function updateUI()
  ui.spellSwitch:setOn(spellMacro:isOn())
  ui.potSwitch:setOn(potMacro:isOn())

  storage.healing_master  = spellMacro:isOn()
  storage.potions_enabled = potMacro:isOn()

  local cur = storage.healProfiles.current
  for _,id in ipairs({"EK","RP","ED","MS"}) do
    ui.profileButtons[id]:setColor(cur == id and "#55ff55" or "white")
  end
end

local function setSpell(state)
  spellMacro:setOn(state)
  storage.healing_master = state
  ui.spellSwitch:setOn(state)
end

local function setPot(state)
  potMacro:setOn(state)
  storage.potions_enabled = state
  ui.potSwitch:setOn(state)
end

local function setProfile(name)
  storage.healProfiles.current = name
  storage.potProfiles.current = name
  updateUI()
  if setup:isVisible() then refreshSetup() end
end

-- =========================
-- MACROS
-- =========================
spellMacro = macro(200,function()
  local player = getPlayer()
  if not player or not spellMacro:isOn() then return end

  local cfg = storage.healProfiles[storage.healProfiles.current]
  local hp = player:getHealthPercent()

  for _,heal in ipairs({cfg.h2,cfg.h1}) do
    if heal.on and hp >= heal.min and hp <= heal.max then
      say(heal.text)
      return
    end
  end
end)

potMacro = macro(250,function()
  local player = getPlayer()
  if not player or not potMacro:isOn() then return end

  local cfg = storage.potProfiles[storage.potProfiles.current]

  for _,pot in ipairs(cfg) do
    local percent = 0

    if pot.type == "hp" then
      percent = player:getHealthPercent()
    else
      percent = math.floor(100 * (player:getMana() / math.max(player:getMaxMana(),1)))
    end

    if pot.on and percent >= pot.min and percent <= pot.max then
      g_game.useInventoryItemWith(pot.item, player)
      return
    end
  end
end)

-- =========================
-- BUTTON EVENTS
-- =========================
ui.spellSwitch.onClick = function()
  setSpell(not spellMacro:isOn())
end

ui.potSwitch.onClick = function()
  setPot(not potMacro:isOn())
end

ui.settings.onClick = function()
  if setup:isVisible() then
    setup:hide()
  else
    setup:show()
    refreshSetup()
  end
end

ui.profileButtons.EK.onClick = function() setProfile("EK") end
ui.profileButtons.RP.onClick = function() setProfile("RP") end
ui.profileButtons.ED.onClick = function() setProfile("ED") end
ui.profileButtons.MS.onClick = function() setProfile("MS") end

-- =========================
-- ICONS
-- =========================
local spellIcon = addIcon("spellIcon",{text="SPELL",item=23528},spellMacro)
spellIcon:breakAnchors()
spellIcon:move(storage.iconSpellPos.x, storage.iconSpellPos.y)
spellIcon:setDraggable(true)

local potIcon = addIcon("potIcon",{text="POT",item=23526},potMacro)
potIcon:breakAnchors()
potIcon:move(storage.iconPotPos.x, storage.iconPotPos.y)
potIcon:setDraggable(true)

-- =========================
-- WATCHER (UI + SAVE POS)
-- =========================
macro(200,function()
  updateUI()

  if spellIcon then
    local pos = spellIcon:getPosition()
    storage.iconSpellPos = {x = pos.x, y = pos.y}
  end

  if potIcon then
    local pos = potIcon:getPosition()
    storage.iconPotPos = {x = pos.x, y = pos.y}
  end
end)

-- =========================
-- START
-- =========================
setSpell(storage.healing_master)
setPot(storage.potions_enabled)
updateUI()

UI.Separator()

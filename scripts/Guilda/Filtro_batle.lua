setDefaultTab("main")

local FiltroPainel = setupUI([[
Panel
  height: 55
  margin-top: 5

  Label
    id: titleBase
    text: FILTRO BATTLE
    font: verdana-11px-rounded
    color: #FFFFFF
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter
    height: 20

  Panel
    id: waveContainer
    anchors.top: titleBase.top
    anchors.left: titleBase.left
    height: 20
    width: 40
    clipping: true
    phantom: true
    Label
      id: titleWave
      text: FILTRO BATTLE
      font: verdana-11px-rounded
      color: #FF0000
      anchors.top: parent.top
      anchors.left: parent.left
      width: 120

  Panel
    id: icons
    height: 32
    anchors.top: titleBase.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    background-color: #00000090
    border-width: 1
    border-color: #FFFFFF
    padding: 4

    BattlePlayers
      id: players
      anchors.left: parent.left
      margin-left: 25
      image-source: /images/game/battle/battle_players
      border-width: 1

    BattleNPCs
      id: npcs
      anchors.left: prev.right
      margin-left: 10
      image-source: /images/game/battle/battle_npcs
      border-width: 1

    BattleMonsters
      id: mobs
      anchors.left: prev.right
      margin-left: 10
      image-source: /images/game/battle/battle_monsters
      border-width: 1

    BattleSkulls
      id: sempk
      anchors.left: prev.right
      margin-left: 10
      image-source: /images/game/battle/battle_skulls
      border-width: 1

    BattleParty
      id: party
      anchors.left: prev.right
      margin-left: 10
      image-source: /images/game/battle/battle_party
      border-width: 1
]], parent)

storage.FiltroPlayers = storage.FiltroPlayers or false
storage.FiltroNpcs = storage.FiltroNpcs or false
storage.FiltroMobs = storage.FiltroMobs or false
storage.FiltroSkull = storage.FiltroSkull or false
storage.FiltroParty = storage.FiltroParty or false

macro(50, function()
  if not FiltroPainel then return end

  local speed = 2000 
  local titleWidth = FiltroPainel.titleBase:getWidth()
  local scanWidth = 45 
  local currentTime = os.clock() * 1000

  local progress = (currentTime % speed) / speed
  local xPos = (progress * (titleWidth + scanWidth)) - scanWidth
  
  FiltroPainel.waveContainer:setMarginLeft(xPos)
  FiltroPainel.waveContainer:setWidth(scanWidth)
  FiltroPainel.waveContainer.titleWave:setMarginLeft(-xPos)

  FiltroPainel.icons.players:setBorderColor(storage.FiltroPlayers and "#FF0000" or "#FFFFFF")
  FiltroPainel.icons.npcs:setBorderColor(storage.FiltroNpcs and "#FF0000" or "#FFFFFF")
  FiltroPainel.icons.mobs:setBorderColor(storage.FiltroMobs and "#FF0000" or "#FFFFFF")
  FiltroPainel.icons.sempk:setBorderColor(storage.FiltroSkull and "#FF0000" or "#FFFFFF")
  FiltroPainel.icons.party:setBorderColor(storage.FiltroParty and "#FF0000" or "#FFFFFF")
  
  FiltroPainel.icons.players:setImageColor(storage.FiltroPlayers and '#696969' or '#FFFFFF')
  FiltroPainel.icons.npcs:setImageColor(storage.FiltroNpcs and '#696969' or '#FFFFFF')
  FiltroPainel.icons.mobs:setImageColor(storage.FiltroMobs and '#696969' or '#FFFFFF')
  FiltroPainel.icons.sempk:setImageColor(storage.FiltroSkull and '#696969' or '#FFFFFF')
  FiltroPainel.icons.party:setImageColor(storage.FiltroParty and '#696969' or '#FFFFFF')
end)

FiltroPainel.icons.players.onClick = function() storage.FiltroPlayers = not storage.FiltroPlayers end
FiltroPainel.icons.npcs.onClick = function() storage.FiltroNpcs = not storage.FiltroNpcs end
FiltroPainel.icons.mobs.onClick = function() storage.FiltroMobs = not storage.FiltroMobs end
FiltroPainel.icons.sempk.onClick = function() storage.FiltroSkull = not storage.FiltroSkull end
FiltroPainel.icons.party.onClick = function() storage.FiltroParty = not storage.FiltroParty end

FiltrarBattle = macro(1, function() end)
modules.game_battle.doCreatureFitFilters = function(creature)
    if not FiltrarBattle.isOn() then return true end
    if creature:isLocalPlayer() or creature:getHealthPercent() <= 0 then return false end
    if creature:isMonster() and storage.FiltroMobs then return false end
    if creature:isPlayer() and storage.FiltroPlayers then return false end
    if creature:isNpc() and storage.FiltroNpcs then return false end
    if creature:isPlayer() and (creature:getEmblem() == 1 or creature:getShield() >= 3) and storage.FiltroParty then return false end
    if creature:isPlayer() and creature:getSkull() == 0 and storage.FiltroSkull then return false end
    return true
end

setDefaultTab("main")

local playerGuildName = "Nao Afiliado"
local lastLook = 0

-- Lógica para capturar a guilda pelo texto do Look
onTextMessage(function(mode, text)
    if text:find("You see yourself") or text:find("You see " .. player:getName()) then
        -- Tenta encontrar o padrão de guilda no texto
        local guild = text:match("of the (.-)%.")
        if guild then 
            playerGuildName = guild 
        else
            playerGuildName = "Sem Guilda"
        end
    end
end)

local ui = setupUI([[
Panel
  height: 220
  background-color: #00000090
  border-width: 1
  border-color: #ffffff
  padding: 5
  margin-top: 3

  Label
    id: playerName
    color: #FFD700
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.horizontalCenter: parent.horizontalCenter

  Label
    id: playerGuild
    font: verdana-11px-rounded
    anchors.top: prev.bottom
    anchors.horizontalCenter: parent.horizontalCenter

  Label
    id: skillHeaderBase
    text: --- STATUS ---
    color: #FFFFFF
    font: verdana-11px-rounded
    anchors.top: prev.bottom
    anchors.horizontalCenter: parent.horizontalCenter
    margin-top: 5

  Panel
    id: sLevel
    height: 15
    anchors.top: skillHeaderBase.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200

  Panel
    id: sStamina
    height: 15
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200

  Panel
    id: sML
    height: 15
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 10
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200

  Panel
    id: sClub
    height: 15
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200

  Panel
    id: sSword
    height: 15
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200

  Panel
    id: sAxe
    height: 15
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200

  Panel
    id: sDist
    height: 15
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200

  Panel
    id: sShield
    height: 15
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    Label
      id: b
      color: #FFFFFF
      font: verdana-11px-rounded
      anchors.left: parent.left
      margin-left: 5
    Panel
      id: w
      anchors.fill: b
      clipping: true
      phantom: true
      Label
        id: t
        color: #FF0000
        font: verdana-11px-rounded
        anchors.left: parent.left
        width: 200
]], parent)

macro(200, function() -- Aumentei para 200ms para evitar o erro de "Slow Macro"
    if not player or not ui then return end
    
    -- Lógica de Look automático (roda a cada 10 segundos até achar a guilda)
    if (playerGuildName == "Nao Afiliado") and (os.time() > lastLook + 10) then
        g_game.look(player)
        lastLook = os.time()
    end

    local speed = 2500
    local scanWidth = 50
    local currentTime = os.clock() * 1000

    local function animateLine(panel, delay)
        if not panel or not panel.b or not panel.w then return end
        local width = panel.b:getWidth()
        local progress = ((currentTime + delay) % speed) / speed
        local xPos = (progress * (width + scanWidth)) - scanWidth
        
        panel.w:setMarginLeft(xPos)
        panel.w:setWidth(scanWidth)
        
        panel.w.t:setText(panel.b:getText())
        panel.w.t:setMarginLeft(-xPos)
    end

    animateLine(ui.sLevel, 0)
    animateLine(ui.sStamina, 150)
    animateLine(ui.sML, 300)
    animateLine(ui.sClub, 450)
    animateLine(ui.sSword, 600)
    animateLine(ui.sAxe, 750)
    animateLine(ui.sDist, 900)
    animateLine(ui.sShield, 1050)

    local pulse = math.abs(math.sin(os.clock() * 4))
    ui:setBorderColor(string.format("#FF%02X%02X", math.floor(255 * (1-pulse)), math.floor(255 * (1-pulse))))

    ui.playerName:setText("Player: " .. player:getName())
    ui.playerGuild:setText("Guild: " .. playerGuildName)
    ui.playerGuild:setColor((playerGuildName == "Nao Afiliado" or playerGuildName == "Sem Guilda") and "#FF0000" or "#00FF00")

    local stamMinutes = player:getStamina()
    local hours = math.floor(stamMinutes / 60)
    local minutes = stamMinutes % 60
    local staminaText = string.format("%02d:%02d", hours, minutes)

    ui.sLevel.b:setText("Level: " .. player:getLevel() .. " (" .. player:getLevelPercent() .. "%)")
    ui.sStamina.b:setText("Stamina: " .. staminaText)
    ui.sML.b:setText("Magic: " .. player:getMagicLevel() .. " (" .. player:getMagicLevelPercent() .. "%)")
    ui.sClub.b:setText("Club: " .. player:getSkillLevel(0) .. " (" .. player:getSkillLevelPercent(0) .. "%)")
    ui.sSword.b:setText("Sword: " .. player:getSkillLevel(2) .. " (" .. player:getSkillLevelPercent(2) .. "%)")
    ui.sAxe.b:setText("Axe: " .. player:getSkillLevel(3) .. " (" .. player:getSkillLevelPercent(3) .. "%)")
    ui.sDist.b:setText("Distance: " .. player:getSkillLevel(4) .. " (" .. player:getSkillLevelPercent(4) .. "%)")
    ui.sShield.b:setText("Shield: " .. player:getSkillLevel(5) .. " (" .. player:getSkillLevelPercent(5) .. "%)")
end)

setDefaultTab("HP") -- Garante que os créditos apareçam na aba HP do Healer

-- =============================================================================
-- [PAINEL DE CRÉDITOS E SUPORTE - BRINQUE SCRIPT NATIVO ANIMADO]
-- =============================================================================
local version = "2.1"
local currentVersion
local available = false

storage.checkVersion = storage.checkVersion or 0

-- 1. Rótulo Principal: Nome da Marca Destacado em Amarelo Ouro Original
local labelBrinqueMarca = UI.Label("HEALING BRINQUE v" .. version)
if labelBrinqueMarca then
    labelBrinqueMarca:setColor("#ffcc00") -- Cor Ouro de Elite
    labelBrinqueMarca:setFont("verdana-11px-rounded") -- Fonte com contorno limpo
end



-- =============================================================================
-- [MOTOR DE PISCAR SIMPLES] DEGRADE CONTÍNUO EM LOOP DE BACKGROUND (SEM CRASH)
-- =============================================================================
macro(150, function()
    if not labelBrinqueMarca then return end

    -- Coleta o tempo atual em ondas matemáticas (Seno de frequência rápida)
    local tempoOnda = os.clock() * 5
    local pulsoIntensidade = math.abs(math.sin(tempoOnda))

    -- 1. FAZ A LOGO "HEALING BRINQUE" PISCAR EM DEGRADÊ (AMARELO OURO <-> LARANJA WAR)
    local gLogo = math.floor(100 + (105 * pulsoIntensidade)) -- Oscila o tom de Verde do RGB
    local corLogoHex = string.format("#FF%02X00", gLogo)
    labelBrinqueMarca:setColor(corLogoHex)
end)

----------

-- TRAVA ANTI-BUG DEFINITIVA: Neutraliza loops fantasmas na memória do client
if not updateDropUI then function updateDropUI() end end
if not updateOlheiroUI then function updateOlheiroUI() end end

local widgetRaizDoJogo = g_ui.getRootWidget()

setDefaultTab("HP")

storage.healing_master   = storage.healing_master or false
storage.potions_enabled  = storage.potions_enabled or false
storage.iconSpellPos     = storage.iconSpellPos or {x=200,y=120}
storage.iconPotPos       = storage.iconPotPos or {x=260,y=120}

-- =============================================================================
-- [BLOCO OTUI SUPREMO] BOTÕES DO RODAPÉ EM LINHA DE MONTAGEM (100% IMÓVEIS)
-- =============================================================================
healerMainWindow = setupUI([[
MainWindow
  id: janelaHealerUltimateFlutuante
  size: 260 410
  anchors.centerIn: parent
  draggable: true
  @onEscape: self:hide()

  UIWidget
    id: topUI
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20
    backgroundColor: #00000088
    Label
      id: title
      anchors.fill: parent
      text-align: center
      font: verdana-11px-rounded
      color: #e6bc22
      text: >> Healing de vocacoes <<

  UIWidget
    id: uiPanel
    anchors.top: topUI.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    height: 82

    BotSwitch
      id: spellSwitch
      anchors.top: parent.top
      anchors.left: parent.left
      width: 64
      height: 18
      !text: tr('Spell')

    BotSwitch
      id: potSwitch
      anchors.top: parent.top
      anchors.left: spellSwitch.right
      margin-left: 2
      width: 64
      height: 18
      !text: tr('Potion')

    Button
      id: settings
      anchors.top: parent.top
      anchors.left: potSwitch.right
      anchors.right: parent.right
      margin-left: 3
      height: 17
      text: Setup

    UIWidget
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

  UIWidget
    id: setupWindow
    anchors.top: uiPanel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 210
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

  Label
    id: lblMarcaDaguaBrinque
    text: >> BRINQUE SCRIPT v3.0 <<
    font: verdana-11px-rounded
    anchors.bottom: closeBtn.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-bottom: 8
    text-align: center

  -- AJUSTADO: Botão de fechar ocupa a metade esquerda e serve de âncora horizontal
  Button
    id: closeBtn
    text: Fechar
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 2
    height: 20

  -- TRAVA SUPREMA: Botão Discord embutido nativamente na string para nunca mais flutuar solto!
  Button
    id: btnDiscordOficial
    text: Discord
    anchors.bottom: parent.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 2
    height: 20
]], widgetRaizDoJogo)

healerMainWindow:hide()

local topUI = healerMainWindow.topUI
local ui = healerMainWindow.uiPanel
local setup = healerMainWindow.setupWindow
setup:hide()

-- Conecta a função de clique direto no ID interno trancado
if healerMainWindow.btnDiscordOficial then
    healerMainWindow.btnDiscordOficial.onClick = function()
        g_platform.openUrl("https://discord.gg/u6cjGDg3UH")
    end
end

local painelDaAbaTools = getTab("hp")
if painelDaAbaTools:recursiveGetChildById("panelHealerBotoesNativos") then
    painelDaAbaTools:recursiveGetChildById("panelHealerBotoesNativos"):destroy()
end

botoesHealerUI = setupUI([[
Panel
  id: panelHealerBotoesNativos
  height: 17
  margin-top: 4

  Button
    id: btnAbrePainelHealer
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 17
    text: Config Healer Ultimate
]], painelDaAbaTools)

-- =============================================================================
-- BANCO DE DADOS E PERFIS (STORAGE ORIGINAL INTEGRADO)
-- =============================================================================
storage.healProfiles = storage.healProfiles or {
current = "EK",
EK = { h1={on=true,title="High",text="exura ico",min=70,max=90}, h2={on=true,title="Low", text="exura med ico",min=0,max=69} },
RP = { h1={on=true,title="High",text="exura san",min=60,max=90}, h2={on=true,title="Low", text="exura gran san",min=0,max=59} },
ED = { h1={on=true,title="High",text="exura",min=80,max=95}, h2={on=true,title="Low", text="exura gran res",min=0,max=79} },
MS = { h1={on=true,title="High",text="exura",min=70,max=95}, h2={on=true,title="Low", text="exura vita",min=0,max=69} }
}

storage.potProfiles = storage.potProfiles or {
current = "EK",
EK = { {on=true,title="HP",item=266,min=0,max=80,type="hp"}, {on=true,title="MP",item=268,min=0,max=100,type="mp"} },
RP = { {on=true,title="HP",item=266,min=0,max=80,type="hp"}, {on=true,title="MP",item=268,min=0,max=100,type="mp"} },
ED = { {on=true,title="HP",item=266,min=0,max=100,type="hp"}, {on=true,title="MP",item=268,min=0,max=100,type="mp"} },
MS = { {on=true,title="HP",item=266,min=0,max=100,type="hp"}, {on=true,title="MP",item=268,min=0,max=100,type="mp"} }
}

local function refreshSetup()
  local setup = healerMainWindow.setupWindow
  if not setup or not setup.container then return end
  setup.container:destroyChildren()
  local cur = storage.healProfiles.current
  local spell = storage.healProfiles[cur]
  local pot   = storage.potProfiles[cur]
  if UI.DualScrollPanel then
    for _,cfg in ipairs({spell.h1, spell.h2}) do
      UI.DualScrollPanel(cfg,function(widget,new) for k,v in pairs(new) do cfg[k]=v end end,setup.container)
    end
  end
  if UI.DualScrollItemPanel then
    for _,cfg in ipairs(pot) do
      UI.DualScrollItemPanel(cfg,function(widget,new) for k,v in pairs(new) do cfg[k]=v end end,setup.container)
    end
  end
end

local function updateUI()
  local ui = healerMainWindow.uiPanel
  if not ui or not ui.spellSwitch or not ui.potSwitch then return end
  ui.spellSwitch:setOn(spellMacro:isOn())
  ui.potSwitch:setOn(potMacro:isOn())
  storage.healing_master  = spellMacro:isOn()
  storage.potions_enabled = potMacro:isOn()
  local cur = storage.healProfiles.current
  for _,id in ipairs({"EK","RP","ED","MS"}) do
    if ui.profileButtons[id] then ui.profileButtons[id]:setColor(cur == id and "#55ff55" or "white") end
  end
end

local function setSpell(state)
  spellMacro:setOn(state)
  storage.healing_master = state
  local ui = healerMainWindow.uiPanel
  if ui and ui.spellSwitch then ui.spellSwitch:setOn(state) end
end

local function setPot(state)
  potMacro:setOn(state)
  storage.potions_enabled = state
  local ui = healerMainWindow.uiPanel
  if ui and ui.potSwitch then ui.potSwitch:setOn(state) end
end

local function setProfile(name)
  storage.healProfiles.current = name
  storage.potProfiles.current = name
  updateUI()
  local setup = healerMainWindow.setupWindow
  if setup and setup:isVisible() then refreshSetup() end
end
-- =============================================================================
-- [BLOCO 5] OS MOTORES DOS MACROS DE CURA (EXECUÇÃO ORIGINAL)
-- =============================================================================
local function getPlayer()
  return g_game.getLocalPlayer()
end

spellMacro = macro(200, function()
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

potMacro = macro(250, function()
  local player = getPlayer()
  if not player or not potMacro:isOn() then return end

  local curProfile = storage.potProfiles.current or "EK"
  local cfg = storage.potProfiles[curProfile]
  if not cfg then return end

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

-- =============================================================================
-- [BLOCO 6] ARREMATES DE EVENTOS DE CLIQUES E VÍNCULOS GRÁFICOS
-- =============================================================================
local ui = healerMainWindow.uiPanel
local setup = healerMainWindow.setupWindow
local topUI = healerMainWindow.topUI

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

botoesHealerUI.btnAbrePainelHealer.onClick = function()
  if healerMainWindow:isVisible() then
    healerMainWindow:hide()
  else
    healerMainWindow:show()
    healerMainWindow:raise()
    healerMainWindow:focus()
    updateUI()
  end
end

healerMainWindow.closeBtn.onClick = function()
  healerMainWindow:hide()
end

-- =============================================================================
-- ICONS (MÉTODO DO SEU MODELO ORIGINAL COM ARRASTE LIVRE)
-- =============================================================================
local spellIcon = addIcon("spellIcon",{text="SPELL",item=23528},spellMacro)
spellIcon:breakAnchors()
spellIcon:setDraggable(true)
if storage.iconSpellPos then
  spellIcon:move(storage.iconSpellPos.x, storage.iconSpellPos.y)
end

local potIcon = addIcon("potIcon",{text="POT",item=23526},potMacro)
potIcon:breakAnchors()
potIcon:setDraggable(true)
if storage.iconPotPos then
  potIcon:move(storage.iconPotPos.x, storage.iconPotPos.y)
end

-- =============================================================================
-- WATCHER CRONOMETRADO (GRAVAÇÃO DE POSIÇÕES + SUA MARCA PULSANTE)
-- =============================================================================
macro(100, function()
  updateUI()

  if spellIcon then
    local pos = spellIcon:getPosition()
    storage.iconSpellPos = {x = pos.x, y = pos.y}
  end

  if potIcon then
    local pos = potIcon:getPosition()
    storage.iconPotPos = {x = pos.x, y = pos.y}
  end

  -- Mantém a pulsação matemática suave em seno na sua assinatura no rodapé
  if healerMainWindow and healerMainWindow:isVisible() and healerMainWindow.lblMarcaDaguaBrinque then
    local equacaoSeno = math.abs(math.sin(os.clock() * 4))
    local tomDeCinza = math.floor(100 + (155 * equacaoSeno))
    healerMainWindow.lblMarcaDaguaBrinque:setColor(string.format("#%02X%02X%02X", tomDeCinza, tomDeCinza, tomDeCinza))
  end
end)

setSpell(storage.healing_master)
setPot(storage.potions_enabled)
updateUI()

UI.Separator()



-- =============================================================================
-- [BRINQUE SCRIPTS] MACRO DE AVISO OBRIGATÓRIO DE MIGRAÇÃO V2.0 - PARTE 1 DE 2
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()
local painelAvisoVelho = widgetRaizDoJogo:recursiveGetChildById("janelaAvisoMigracaoV2")
if painelAvisoVelho then painelAvisoVelho:destroy() end

local LINK_SUPORTE_WHATSAPP = "https://chat.whatsapp.com/D4WHVuAy41t6uQ6QZ3ibtR"

-- 🛠️ CORREÇÃO SUPREMA: Âncoras separadas linha por linha e removido os comentários internos
local designAvisoOTUI = "UIWindow\n" ..
"  id: janelaAvisoMigracaoV2\n" ..
"  size: 1000 300\n" ..
"  anchors.horizontalCenter: parent.horizontalCenter\n" ..
"  anchors.verticalCenter: parent.verticalCenter\n" ..
"  clipping: true\n" ..
"  padding: 15\n" ..
"  layout: anchor\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #000000D5\n" ..
"    anchors.fill: parent\n" ..
"    margin: 0\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblTituloAviso\n" ..
"    text: !!! ALERTA DE ATUALIZACAO EM 1 MINUTO O PAINEL SAI!!!\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ff4444\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblCorpoAviso\n" ..
"    text: Comunicamos Que Esta versao 2.0 sera DESATIVADA. Por favor, entre em contato com a administracao Pelo link Não fique sem as Suas scripts!\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: lblTituloAviso.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  Button\n" ..
"    id: btnFalarSuporte\n" ..
"    text: FALAR COM A ADMINISTRACAO\n" ..
"    color: #00ff00\n" ..
"    font: verdana-11px-rounded\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-border: 5\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.horizontalCenter: parent.horizontalCenter\n" ..
"    margin-bottom: 10\n" ..
"    size: 260 26\n"

janelaAvisoMestre = setupUI(designAvisoOTUI, widgetRaizDoJogo)
janelaAvisoMestre:show()
janelaAvisoMestre:raise()
janelaAvisoMestre:focus()
-- =============================================================================
-- [BRINQUE SCRIPTS] MACRO DE AVISO OBRIGATÓRIO DE MIGRAÇÃO V2.0 - PARTE 2 DE 2
-- =============================================================================

-- Vincula a ação de clique para abrir o WhatsApp de suporte do administrador
janelaAvisoMestre.btnFalarSuporte.onClick = function()
    if g_signals and g_signals.openUrl then 
        g_signals.openUrl(LINK_SUPORTE_WHATSAPP)
    elseif g_platform and g_platform.openUrl then 
        g_platform.openUrl(LINK_SUPORTE_WHATSAPP)
    else 
        print(">>> [BRINQUE] Acesse o suporte pelo link: " .. LINK_SUPORTE_WHATSAPP) 
    end
end

-- 🧠 TEMPORIZADOR DE MIGRACAO: Conta exatamente 1 minuto (60000ms) e fecha o painel
schedule(60000, function()
    -- Procura o modal ativo diretamente pelo ID na raiz gráfica para evitar vazamentos de memória
    local widgetAlvoParaFechar = g_ui.getRootWidget():recursiveGetChildById("janelaAvisoMigracaoV2")
    if widgetAlvoParaFechar then
        widgetAlvoParaFechar:destroy()
        print("[Brinque] O painel de aviso foi fechado automaticamente apos 1 minuto.")
    end
end)

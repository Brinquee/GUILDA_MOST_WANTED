local widgetRaizDoJogo = g_ui.getRootWidget()
local idPainelFuga = "janelaFugaConfig"
local idPainelEdit = "janelaFugaEditPop"

-- =============================================================================
-- [BLOCO 1] MEMORIA UNIFICADA (STORAGE ATUALIZADO)
-- =============================================================================
setDefaultTab("Cave")

if not storage.fugaDanoDefinitivo then
    storage.fugaDanoDefinitivo = {
        macroAtiva = false,
        minimoPlayers = 2,
        labelDestino = "fugir",
        labelAtivarMonit = "start",
        labelReativar = "check",
        fugaPorMW = false,
        fugaPorGrav = false,
        idMW = "2128",
        idGrav = "3156",
        monitManual = false,
        tempoAutoVoltarSegundos = 15,
        fugaPorMsg = false, 
        nomeOlheiro = "Nome do Olheiro", 
        textoAlerta = "pk",
        reativarPorLabel = true,
        ignorarGuild = true,     
        ignorarParty = true,     
        fugaPorDanoPlayer = true 
    }
end

-- =============================================================================
-- [BLOCO 2] JANELA DE CONFIGURACOES COM ASSINATURA CORRIGIDA NA DIREITA
-- =============================================================================
local designPrincipalOTUI = [[
MainWindow
  id: janelaFugaConfig
  !text: tr('Painel de Fuga Inteligente')
  size: 500 480
  @onEscape: self:hide()

  Label
    id: lblFuncoes
    text: == FUNCOES E GATILHOS ==
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5
    width: 220
    text-align: center

  Button
    id: btnLabelAtivarMonit
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 220
    height: 24

  Button
    id: btnLabelDestino
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    width: 220
    height: 24

  Button
    id: btnLabelReativar
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    width: 220
    height: 24

  Button
    id: btnTempoAutoVoltar
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    width: 220
    height: 24

  Button
    id: btnPlayers
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 8
    width: 220
    height: 24

  BotSwitch
    id: swIgnorarGuild
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 220
    height: 20

  BotSwitch
    id: swIgnorarParty
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 6
    width: 220
    height: 20

  BotSwitch
    id: swFugaDano
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 6
    width: 220
    height: 20

  BotSwitch
    id: swMW
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 220
    height: 20

  Button
    id: btnIDMW
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 4
    width: 220
    height: 24

  BotSwitch
    id: swGrav
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 10
    width: 220
    height: 20

  Button
    id: btnIDGrav
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 4
    width: 220
    height: 24

  BotSwitch
    id: swManual
    anchors.top: prev.bottom
    anchors.left: parent.left
    margin-top: 12
    width: 220
    height: 22

  Label
    id: lblStatusTitulo
    text: == MONITOR DE STATUS ==
    font: verdana-11px-rounded
    anchors.top: parent.top
    anchors.left: parent.horizontalCenter
    margin-left: 10
    width: 220
    text-align: center

  Label
    id: lblStatusSistema
    text: Status: DESLIGADO
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 15
    margin-left: 10
    width: 220
    text-align: center

  Label
    id: lblStatusMonit
    text: Sensor: INATIVO
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 8
    margin-left: 10
    width: 220
    text-align: center

  Button
    id: btnResetManualFuga
    text: RESETAR FUGA MANUAL
    color: #ffaa44
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 12
    margin-left: 10
    width: 220
    height: 24

  Label
    id: lblOlheiroTitulo
    text: == ALERTA DO OLHEIRO ==
    font: verdana-11px-rounded
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-left: 10
    width: 220
    text-align: center

  BotSwitch
    id: swMsg
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 10
    margin-left: 10
    width: 220
    height: 20

  Button
    id: btnOlheiro
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 4
    margin-left: 10
    width: 220
    height: 24

  Button
    id: btnAlerta
    anchors.top: prev.bottom
    anchors.left: parent.horizontalCenter
    margin-top: 4
    margin-left: 10
    width: 220
    height: 24

  -- CORREÇÃO DA POSIÇÃO: Travado na borda direita com 15px de distância
  Label
    id: lblMarcaDaguaUniversal
    text: >> HEALING ULTIMATE v4.8 <<
    font: verdana-11px-rounded
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    margin-bottom: 45
    margin-right: 15
    width: 220
    text-align: center

  Button
    id: closeBtn
    text: Fechar
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 4
    height: 22

  Button
    id: btnAcessarUrl
    text: Acessar Link
    color: #55ffff
    anchors.bottom: parent.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 4
    height: 22
]]

local designPopUpOTUI = [[
MainWindow
  id: janelaFugaEditPop
  !text: tr('Editar Campo')
  size: 260 130
  anchors.centerIn: parent
  @onEscape: self:hide()

  Label
    id: lblInfo
    text: Digite o novo valor:
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 5

  TextEdit
    id: txtEntrada
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5

  Button
    id: btnConfirmar
    text: CONFIRMAR
    color: green
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 4

  Button
    id: btnCancelar
    text: Cancelar
    anchors.bottom: parent.bottom
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 4
]]

local fugaWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
local editWindow = setupUI(designPopUpOTUI, widgetRaizDoJogo)
fugaWindow:hide()
editWindow:hide()

function updateFugaUI() end

local painelDaAba = getTab("Cave")
if painelDaAba:recursiveGetChildById("panelBotoesFugaNativos") then
    painelDaAba:recursiveGetChildById("panelBotoesFugaNativos"):destroy()
end

local botoesFugaUI = setupUI([[
Panel
  id: panelBotoesFugaNativos
  height: 18
  margin-top: 5
  layout:
    type: horizontalBox
    spacing: 4

  BotSwitch
    id: btnLigaMacroFugir
    width: 85

  Button
    id: btnAbrePainelFugir
    text: Config Fuga
    width: 85
]], painelDaAba)
-- =============================================================================
-- [BLOCO 3] LOGICA DOS MOTORES INTEGRADOS (CORREÇÃO: ESCUDO AZUL COMO INIMIGO)
-- =============================================================================
local tempoInicioFuga = 0
local dispararFugaPorMensagem = false
local acionarResetManualImediato = false
local gatilhoDanoInimigoForzado = false

local function checarSeExisteFieldNoChao(idMW, idGrav, buscarMW, buscarGrav)
    if not buscarMW and not buscarGrav then return false end
    for _, tile in ipairs(g_map.getTiles(posz())) do
        if tile then
            local topThing = tile:getTopUseThing()
            if topThing then
                local itemId = topThing:getId()
                if buscarMW and itemId == idMW then return true end
                if buscarGrav and itemId == idGrav then return true end
            end
        end
    end
    return false
end

-- SENSOR DE DANO CORRIGIDO: Escudo Azul (3, 13) e Escudo Vermelho (2, 4, 12, 14) disparam fuga obrigatoriamente
if g_signals and g_signals.connect then
    g_signals.connect(LocalPlayer, 'onHealthChange', function(meuPlayerChar, health, maxHealth, oldHealth, oldMaxHealth)
        if not storage.fugaDanoDefinitivo or not storage.fugaDanoDefinitivo.macroAtiva or not storage.fugaDanoDefinitivo.fugaPorDanoPlayer then return end
        if storage.fugaDanoDefinitivo.emEstadoDeFuga or not monitoramentoAtivo then return end

        if health < oldHealth then
            local meuPlayer = g_game.getLocalPlayer()
            if not meuPlayer then return end

            for _, creature in ipairs(g_map.getSpectators(meuPlayer:getPosition(), false)) do
                if creature:isPlayer() and creature:getName() ~= meuPlayer:getName() and creature:isTimedControlled() then
                    local deveIgnorar = false
                    local alvoEmblem = creature:getEmblem() 

                    -- 1. Filtro Party/Aliados Diretos
                    if storage.fugaDanoDefinitivo.ignorarParty and creature.isPartyMember and creature:isPartyMember() then 
                        deveIgnorar = true 
                    end
                    
                    -- 2. Filtro Guilda: Apenas o Emblema Verde (ID 1 ou 11) e ignorado
                    if not deveIgnorar and storage.fugaDanoDefinitivo.ignorarGuild then
                        if alvoEmblem == 1 or alvoEmblem == 11 then 
                            deveIgnorar = true
                        end
                    end

                    -- Se o emblema for Azul (3, 13) ou Vermelho (2, 4, 12, 14), o bot nao ignora mais e dispara a fuga por dano
                    if not deveIgnorar then
                        gatilhoDanoInimigoForzado = true
                        break
                    end
                end
            end
        end
    end)
end

onTalk(function(name, level, mode, text, channelId)
    if not storage.fugaDanoDefinitivo or not storage.fugaDanoDefinitivo.macroAtiva or not storage.fugaDanoDefinitivo.fugaPorMsg then return end
    local olheiroConfigurado = tostring(storage.fugaDanoDefinitivo.nomeOlheiro or "Nome do Olheiro"):lower()
    local palavraChaveConfigurada = tostring(storage.fugaDanoDefinitivo.textoAlerta or "pk"):lower()
    if name:lower() == olheiroConfigurado and text:lower():find(palavraChaveConfigurada) then
        dispararFugaPorMensagem = true
    end
end)

local function obterLabelAtualDoCaveBot()
    local labelAtualRaw = ""
    if CaveBot.getCurrentLabel then labelAtualRaw = CaveBot.getCurrentLabel()
    elseif CaveBot.currentLabel then labelAtualRaw = CaveBot.currentLabel
    elseif CaveBot.getConfig and CaveBot.getConfig() then labelAtualRaw = CaveBot.getConfig().currentLabel or ""
    elseif CaveBot.config and CaveBot.config.currentLabel then labelAtualRaw = CaveBot.config.currentLabel end
    return tostring(labelAtualRaw):lower():gsub("^%s*(.-)%s*$", "%1")
end

-- MOTOR 1: DETECTOR DE AMEAÇAS DO RADAR (ESCUDO AZUL DEFINIDO COMO INIMIGO ALVO)
local macroFugaDetect = macro(200, function()
    if not CaveBot or not storage.fugaDanoDefinitivo or not storage.fugaDanoDefinitivo.macroAtiva then return end
    if storage.fugaDanoDefinitivo.emEstadoDeFuga then return end 

    local labelAtualDoBot = obterLabelAtualDoCaveBot()
    local alvoAtivar = tostring(storage.fugaDanoDefinitivo.labelAtivarMonit or "start"):lower():gsub("^%s*(.-)%s*$", "%1")
    local alvoFuga = tostring(storage.fugaDanoDefinitivo.labelDestino or "fugir"):lower():gsub("^%s*(.-)%s*$", "%1")

    if storage.fugaDanoDefinitivo.monitManual or labelAtualDoBot == alvoAtivar then
        monitoramentoAtivo = true
    else
        if labelAtualDoBot ~= "" and labelAtualDoBot ~= alvoFuga then
            monitoramentoAtivo = true
        else
            monitoramentoAtivo = false
        end
    end

    local perigoDetectado = false
    local qtdPlayers = 0

    if gatilhoDanoInimigoForzado then perigoDetectado = true gatilhoDanoInimigoForzado = false end
    if dispararFugaPorMensagem then perigoDetectado = true dispararFugaPorMensagem = false end

    if monitoramentoAtivo and not perigoDetectado then
        local tMW = tonumber(storage.fugaDanoDefinitivo.idMW) or 2128
        local tGrav = tonumber(storage.fugaDanoDefinitivo.idGrav) or 3156
        
        if checarSeExisteFieldNoChao(tMW, tGrav, storage.fugaDanoDefinitivo.fugaPorMW, storage.fugaDanoDefinitivo.fugaPorGrav) then
            perigoDetectado = true
        end

        if not perigoDetectado then
            for _, creature in ipairs(g_map.getSpectators(pos(), false)) do
                if creature:isPlayer() and creature ~= player then
                    local deveIgnorar = false
                    local alvoEmblem = creature:getEmblem()

                    if creature.isPartyMember and creature:isPartyMember() then deveIgnorar = true end
                    
                    -- Apenas a guilda verde (1, 11) entra na trava de ignorar do radar
                    if not deveIgnorar and storage.fugaDanoDefinitivo.ignorarGuild then
                        if alvoEmblem == 1 or alvoEmblem == 11 then deveIgnorar = true end
                    end

                    if not deveIgnorar then qtdPlayers = qtdPlayers + 1 end
                end
            end
            if qtdPlayers >= (storage.fugaDanoDefinitivo.minimoPlayers or 2) then perigoDetectado = true end
        end
    end

    if perigoDetectado then
        storage.fugaDanoDefinitivo.emEstadoDeFuga = true
        monitoramentoAtivo = false
        tempoInicioFuga = os.time()
        dispararFugaPorMensagem = false
        gatilhoDanoInimigoForzado = false
        acionarResetManualImediato = false
        
        if CaveBot.changeLabel then CaveBot.changeLabel(storage.fugaDanoDefinitivo.labelDestino or "fugir")
        elseif CaveBot.gotoLabel then CaveBot.gotoLabel(storage.fugaDanoDefinitivo.labelDestino or "fugir") end
    end
end)

-- MOTOR 2: O CONTROLADOR DE REATIVACAO
local macroDestravaFuga = macro(200, function()
    if not CaveBot or not storage.fugaDanoDefinitivo or not storage.fugaDanoDefinitivo.macroAtiva then return end
    if not storage.fugaDanoDefinitivo.emEstadoDeFuga then return end 

    local labelAtualDoBot = obterLabelAtualDoCaveBot()
    local alvoReativar = tostring(storage.fugaDanoDefinitivo.labelReativar or "check"):lower():gsub("^%s*(.-)%s*$", "%1")
    local alvoAtivar = tostring(storage.fugaDanoDefinitivo.labelAtivarMonit or "start"):lower():gsub("^%s*(.-)%s*$", "%1")

    local resetarEstadoVisual = false

    if acionarResetManualImediato then resetarEstadoVisual = true end
    local segundosPassados = os.time() - tempoInicioFuga
    local limiteSegundos = tonumber(storage.fugaDanoDefinitivo.tempoAutoVoltarSegundos) or 15
    if segundosPassados >= limiteSegundos then resetarEstadoVisual = true end
    if storage.fugaDanoDefinitivo.reativarPorLabel and labelAtualDoBot == alvoReativar then resetarEstadoVisual = true end
    if labelAtualDoBot == alvoAtivar then resetarEstadoVisual = true end

    if resetarEstadoVisual then
        storage.fugaDanoDefinitivo.emEstadoDeFuga = false
        monitoramentoAtivo = true
        dispararFugaPorMensagem = false
        gatilhoDanoInimigoForzado = false
        acionarResetManualImediato = false 
        
        if CaveBot.changeLabel then CaveBot.changeLabel(storage.fugaDanoDefinitivo.labelAtivarMonit or "start")
        elseif CaveBot.gotoLabel then CaveBot.gotoLabel(storage.fugaDanoDefinitivo.labelAtivarMonit or "start") end
    end
end)

function forcamentoDoResetFugaSistema()
    if storage.fugaDanoDefinitivo.emEstadoDeFuga then acionarResetManualImediato = true end
end

-- =============================================================================
-- [BLOCO 4] FUNCOES DE SINCRO E GATILHOS VISUAIS
-- =============================================================================
local campoSendoEditadoAtualmente = ""

function abrirEditorPopUp(chaveStorage, rotuloInformacao)
    campoSendoEditadoAtualmente = chaveStorage
    editWindow:setText("Editar: " .. rotuloInformacao)
    editWindow.lblInfo:setText("Digite o novo valor para " .. rotuloInformacao .. ":")
    local valorAtual = tostring(storage.fugaDanoDefinitivo[chaveStorage] or "")
    editWindow.txtEntrada:setText(valorAtual)
    editWindow:show()
    editWindow:raise()
    editWindow:focus()
    editWindow.txtEntrada:focus()
end

function updateFugaUI()
    if not storage.fugaDanoDefinitivo or not fugaWindow then return end
    
    fugaWindow.btnLabelAtivarMonit:setText("Label Ativar Monit: " .. (storage.fugaDanoDefinitivo.labelAtivarMonit or "start"))
    fugaWindow.btnLabelDestino:setText("Label Fuga: " .. (storage.fugaDanoDefinitivo.labelDestino or "fugir"))
    fugaWindow.btnLabelReativar:setText("Label Destravar: " .. (storage.fugaDanoDefinitivo.labelReativar or "check"))
    fugaWindow.btnTempoAutoVoltar:setText("Tempo Auto Voltar: " .. tostring(storage.fugaDanoDefinitivo.tempoAutoVoltarSegundos or 15) .. "s")
    fugaWindow.btnPlayers:setText("Minimo Players: " .. tostring(storage.fugaDanoDefinitivo.minimoPlayers or 2))
    fugaWindow.btnIDMW:setText("ID Magic Wall: " .. (storage.fugaDanoDefinitivo.idMW or "2128"))
    fugaWindow.btnIDGrav:setText("ID Wild Growth: " .. (storage.fugaDanoDefinitivo.idGrav or "3156"))
    
    local olheiroExibir = storage.fugaDanoDefinitivo.nomeOlheiro or "Nome do Olheiro"
    local alertaExibir = storage.fugaDanoDefinitivo.textoAlerta or "pk"
    fugaWindow.btnOlheiro:setText("Olheiro: " .. olheiroExibir)
    fugaWindow.btnAlerta:setText("Palavra Alerta: " .. alertaExibir)
    
    fugaWindow.swIgnorarGuild:setOn(storage.fugaDanoDefinitivo.ignorarGuild)
    fugaWindow.swIgnorarGuild:setText(storage.fugaDanoDefinitivo.ignorarGuild and "Ignorar Guild: ON" or "Ignorar Guild: OFF")
    
    fugaWindow.swIgnorarParty:setOn(storage.fugaDanoDefinitivo.ignorarParty)
    fugaWindow.swIgnorarParty:setText(storage.fugaDanoDefinitivo.ignorarParty and "Ignorar Aliados: ON" or "Ignorar Aliados: OFF")
    
    fugaWindow.swFugaDano:setOn(storage.fugaDanoDefinitivo.fugaPorDanoPlayer)
    fugaWindow.swFugaDano:setText(storage.fugaDanoDefinitivo.fugaPorDanoPlayer and "Fuga por Dano PK: ON" or "Fuga por Dano PK: OFF")
    
    fugaWindow.swMW:setOn(storage.fugaDanoDefinitivo.fugaPorMW)
    fugaWindow.swMW:setText(storage.fugaDanoDefinitivo.fugaPorMW and "Fuga por MW: LIGADA" or "Fuga por MW: DESLIGADA")
    
    fugaWindow.swGrav:setOn(storage.fugaDanoDefinitivo.fugaPorGrav)
    fugaWindow.swGrav:setText(storage.fugaDanoDefinitivo.fugaPorGrav and "Fuga por Grav: LIGADA" or "Fuga por Grav: DESLIGADA")
    
    fugaWindow.swMsg:setOn(storage.fugaDanoDefinitivo.fugaPorMsg)
    fugaWindow.swMsg:setText(storage.fugaDanoDefinitivo.fugaPorMsg and "Fuga por Msg: LIGADA" or "Fuga por Msg: DESLIGADA")
    
    fugaWindow.swManual:setOn(storage.fugaDanoDefinitivo.monitManual)
    fugaWindow.swManual:setText(storage.fugaDanoDefinitivo.monitManual and "Monitoramento Manual: ON" or "Monitoramento Manual: OFF")
    
    botoesFugaUI.btnLigaMacroFugir:setOn(storage.fugaDanoDefinitivo.macroAtiva)
    botoesFugaUI.btnLigaMacroFugir:setText(storage.fugaDanoDefinitivo.macroAtiva and "Fuga: ON" or "Fuga: OFF")

    if not storage.fugaDanoDefinitivo.macroAtiva then
        fugaWindow.lblStatusSistema:setText("Status: DESLIGADO (Macro Off)")
        fugaWindow.lblStatusSistema:setColor("white")
        fugaWindow.lblStatusMonit:setText("Sensor: INATIVO")
        fugaWindow.lblStatusMonit:setColor("white")
    elseif storage.fugaDanoDefinitivo.emEstadoDeFuga then
        fugaWindow.lblStatusSistema:setText("Status: FUGINDO!")
        fugaWindow.lblStatusSistema:setColor("red")
        fugaWindow.lblStatusMonit:setText("Sensor: DORMINDO")
        fugaWindow.lblStatusMonit:setColor("red")
    elseif monitoramentoAtivo then
        fugaWindow.lblStatusSistema:setText("Status: CACANDO")
        fugaWindow.lblStatusSistema:setColor("green")
        fugaWindow.lblStatusMonit:setText("Sensor: BUSCANDO")
        fugaWindow.lblStatusMonit:setColor("green")
    else
        fugaWindow.lblStatusSistema:setText("Status: FORA DO LABEL")
        fugaWindow.lblStatusSistema:setColor("white")
        fugaWindow.lblStatusMonit:setText("Sensor: INATIVO")
        fugaWindow.lblStatusMonit:setColor("white")
    end
end

botoesFugaUI.btnLigaMacroFugir.onClick = function() storage.fugaDanoDefinitivo.macroAtiva = not storage.fugaDanoDefinitivo.macroAtiva updateFugaUI() end
botoesFugaUI.btnAbrePainelFugir.onClick = function() fugaWindow:show() fugaWindow:raise() fugaWindow:focus() updateFugaUI() end

fugaWindow.btnLabelAtivarMonit.onClick = function() abrirEditorPopUp("labelAtivarMonit", "Label Ativar Monitoramento") end
fugaWindow.btnLabelDestino.onClick = function() abrirEditorPopUp("labelDestino", "Label de Fuga") end
fugaWindow.btnLabelReativar.onClick = function() abrirEditorPopUp("labelReativar", "Label de Destravar") end
fugaWindow.btnTempoAutoVoltar.onClick = function() abrirEditorPopUp("tempoAutoVoltarSegundos", "Tempo Voltar (Segundos)") end
fugaWindow.btnPlayers.onClick = function() abrirEditorPopUp("minimoPlayers", "Minimo Players") end
fugaWindow.btnIDMW.onClick = function() abrirEditorPopUp("idMW", "ID Magic Wall") end
fugaWindow.btnIDGrav.onClick = function() abrirEditorPopUp("idGrav", "ID Wild Growth") end
fugaWindow.btnOlheiro.onClick = function() abrirEditorPopUp("nomeOlheiro", "Nome do Olheiro") end
fugaWindow.btnAlerta.onClick = function() abrirEditorPopUp("textoAlerta", "Palavra Alerta") end

fugaWindow.btnResetManualFuga.onClick = function() forcamentoDoResetFugaSistema() updateFugaUI() end

fugaWindow.swIgnorarGuild.onClick = function() storage.fugaDanoDefinitivo.ignorarGuild = not storage.fugaDanoDefinitivo.ignorarGuild updateFugaUI() end
fugaWindow.swIgnorarParty.onClick = function() storage.fugaDanoDefinitivo.ignorarParty = not storage.fugaDanoDefinitivo.ignorarParty updateFugaUI() end
fugaWindow.swFugaDano.onClick = function() storage.fugaDanoDefinitivo.fugaPorDanoPlayer = not storage.fugaDanoDefinitivo.fugaPorDanoPlayer updateFugaUI() end
fugaWindow.swMW.onClick = function() storage.fugaDanoDefinitivo.fugaPorMW = not storage.fugaDanoDefinitivo.fugaPorMW updateFugaUI() end
fugaWindow.swGrav.onClick = function() storage.fugaDanoDefinitivo.fugaPorGrav = not storage.fugaDanoDefinitivo.fugaPorGrav updateFugaUI() end
fugaWindow.swMsg.onClick = function() storage.fugaDanoDefinitivo.fugaPorMsg = not storage.fugaDanoDefinitivo.fugaPorMsg updateFugaUI() end
fugaWindow.swManual.onClick = function() storage.fugaDanoDefinitivo.monitManual = not storage.fugaDanoDefinitivo.monitManual updateFugaUI() end
fugaWindow.closeBtn.onClick = function() fugaWindow:hide() end

fugaWindow.btnAcessarUrl.onClick = function()
    local urlDestino = "https://google.com"
    if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino) end
end

editWindow.btnCancelar.onClick = function() editWindow:hide() end
editWindow.btnConfirmar.onClick = function()
    local textoDigitado = editWindow.txtEntrada:getText()
    if campoSendoEditadoAtualmente ~= "" then
        if campoSendoEditadoAtualmente == "minimoPlayers" or campoSendoEditadoAtualmente == "tempoAutoVoltarSegundos" then 
            storage.fugaDanoDefinitivo[campoSendoEditadoAtualmente] = tonumber(textoDigitado) or 15
        else storage.fugaDanoDefinitivo[campoSendoEditadoAtualmente] = textoDigitado end
    end
    editWindow:hide() updateFugaUI()
end

macro(100, function()
    if botoesFugaUI and storage.fugaDanoDefinitivo then botoesFugaUI.btnLigaMacroFugir:setOn(storage.fugaDanoDefinitivo.macroAtiva) end
    if fugaWindow and fugaWindow:isVisible() and fugaWindow.lblMarcaDaguaUniversal then
        local pulse = math.abs(math.sin(os.clock() * 4))
        local greenBlueBrilho = math.floor(255 * (1 - pulse))
        fugaWindow.lblMarcaDaguaUniversal:setColor(string.format("#FF%02X%02X", greenBlueBrilho, greenBlueBrilho))
    end
    updateFugaUI()
end)

updateFugaUI()

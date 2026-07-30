local widgetRaizDoJogo = g_ui.getRootWidget()
local idPainelFuga = "janelaFugaConfig"
local idPainelEdit = "janelaFugaEditPop"

-- =============================================================================
-- [BLOCO 1] MEMORIA DO SISTEMA (STORAGE)
-- =============================================================================
setDefaultTab("Cave")

if not storage.fugaConfigDuploMotor then
    storage.fugaConfigDuploMotor = {
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
        reativarPorLabel = true 
    }
end

-- =============================================================================
-- [BLOCO 2] JANELA DE CONFIGURACOES (FUNCOES NA ESQUERDA / MONITOR NA DIREITA)
-- =============================================================================
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaFugaConfig\n" ..
"  !text: tr('Painel de Fuga Inteligente')\n" ..
"  size: 500 480\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblFuncoes\n" ..
"    text: == FUNCOES E GATILHOS ==\n" ..
"    color: #ffff00\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnLabelAtivarMonit\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnLabelDestino\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnLabelReativar\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnTempoAutoVoltar\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnPlayers\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 8\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  BotSwitch\n" ..
"    id: swMW\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 10\n" ..
"    width: 220\n" ..
"    height: 20\n" ..
"  Button\n" ..
"    id: btnIDMW\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 4\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  BotSwitch\n" ..
"    id: swGrav\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 10\n" ..
"    width: 220\n" ..
"    height: 20\n" ..
"  Button\n" ..
"    id: btnIDGrav\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 4\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  BotSwitch\n" ..
"    id: swManual\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 12\n" ..
"    width: 220\n" ..
"    height: 22\n" ..
"  Label\n" ..
"    id: lblStatusTitulo\n" ..
"    text: == MONITOR DE STATUS ==\n" ..
"    color: #ffff00\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Label\n" ..
"    id: lblStatusSistema\n" ..
"    text: Status: DESLIGADO\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Label\n" ..
"    id: lblStatusMonit\n" ..
"    text: Sensor: INATIVO\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 8\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  Button\n" ..
"    id: btnResetManualFuga\n" ..
"    text: RESETAR FUGA MANUAL\n" ..
"    color: #ffaa44\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 12\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblOlheiroTitulo\n" ..
"    text: == ALERTA DO OLHEIRO ==\n" ..
"    color: #ffff00\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  BotSwitch\n" ..
"    id: swMsg\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 10\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 20\n" ..
"  Button\n" ..
"    id: btnOlheiro\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 4\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Button\n" ..
"    id: btnAlerta\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 4\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 24\n" ..
"  Label\n" ..
"    id: lblMarcaDagua\n" ..
"    text: >> BRINQUE SCRIPT v1.0 <<\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    text-align: center\n" ..
"  -- ELEMENTO ADICIONADO: Botao de link nativo posicionado abaixo da marca\n" ..
"  Button\n" ..
"    id: btnAcessarUrl\n" ..
"    text: Acessar Discor / Link\n" ..
"    color: #55ffff\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    margin-top: 6\n" ..
"    margin-left: 10\n" ..
"    width: 220\n" ..
"    height: 22\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n"

local designPopUpOTUI = "MainWindow\n" ..
"  id: janelaFugaEditPop\n" ..
"  !text: tr('Editar Campo')\n" ..
"  size: 260 130\n" ..
"  anchors.centerIn: parent\n" ..
"  @onEscape: self:hide()\n" ..
"  Label\n" ..
"    id: lblInfo\n" ..
"    text: Digite o novo valor:\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 5\n" ..
"  TextEdit\n" ..
"    id: txtEntrada\n" ..
"    anchors.top: prev.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 5\n" ..
"  Button\n" ..
"    id: btnConfirmar\n" ..
"    text: CONFIRMAR\n" ..
"    color: green\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-right: 4\n" ..
"  Button\n" ..
"    id: btnCancelar\n" ..
"    text: Cancelar\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 4\n"

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
local emEstadoDeFuga = false
local monitoramentoAtivo = false
local tempoInicioFuga = 0
local dispararFugaPorMensagem = false
local acionarResetManualImediato = false 

onTalk(function(name, level, mode, text, channelId)
    if not storage.fugaConfigDuploMotor or not storage.fugaConfigDuploMotor.macroAtiva or not storage.fugaConfigDuploMotor.fugaPorMsg then return end
    
    local olheiroConfigurado = tostring(storage.fugaConfigDuploMotor.nomeOlheiro or "Nome do Olheiro"):lower()
    local palavraChaveConfigurada = tostring(storage.fugaConfigDuploMotor.textoAlerta or "pk"):lower()
    
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

local macroFugaDetect = macro(200, function()
    if not CaveBot or not storage.fugaConfigDuploMotor or not storage.fugaConfigDuploMotor.macroAtiva then return end
    if emEstadoDeFuga then return end 

    local labelAtualDoBot = obterLabelAtualDoCaveBot()
    local alvoAtivar = tostring(storage.fugaConfigDuploMotor.labelAtivarMonit or "start"):lower():gsub("^%s*(.-)%s*$", "%1")
    local alvoFuga = tostring(storage.fugaConfigDuploMotor.labelDestino or "fugir"):lower():gsub("^%s*(.-)%s*$", "%1")

    if storage.fugaConfigDuploMotor.monitManual or labelAtualDoBot == alvoAtivar then
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

    if dispararFugaPorMensagem then
        perigoDetectado = true
        dispararFugaPorMensagem = false 
    end

    if monitoramentoAtivo and not perigoDetectado then
        if storage.fugaConfigDuploMotor.fugaPorMW or storage.fugaConfigDuploMotor.fugaPorGrav then
            local targetMW = tonumber(storage.fugaConfigDuploMotor.idMW) or 2128
            local targetGrav = tonumber(storage.fugaConfigDuploMotor.idGrav) or 3156

            for _, tile in ipairs(g_map.getTiles(posz())) do
                if tile then
                    local topThing = tile:getTopUseThing()
                    if topThing then
                        local itemId = topThing:getId()
                        if storage.fugaConfigDuploMotor.fugaPorMW and itemId == targetMW then perigoDetectado = true break end
                        if storage.fugaConfigDuploMotor.fugaPorGrav and itemId == targetGrav then perigoDetectado = true break end
                    end
                end
            end
        end

        if not perigoDetectado then
            for _, creature in ipairs(g_map.getSpectators(pos(), false)) do
                if creature:isPlayer() and creature ~= player then
                    qtdPlayers = qtdPlayers + 1
                end
            end
            if qtdPlayers >= (storage.fugaConfigDuploMotor.minimoPlayers or 2) then perigoDetectado = true end
        end
    end

    if perigoDetectado then
        emEstadoDeFuga = true
        monitoramentoAtivo = false
        tempoInicioFuga = os.time()
        dispararFugaPorMensagem = false
        acionarResetManualImediato = false
        
        if CaveBot.changeLabel then
            CaveBot.changeLabel(storage.fugaConfigDuploMotor.labelDestino or "fugir")
        elseif CaveBot.gotoLabel then
            CaveBot.gotoLabel(storage.fugaConfigDuploMotor.labelDestino or "fugir")
        end
    end
end)

local macroDestravaFuga = macro(200, function()
    if not CaveBot or not storage.fugaConfigDuploMotor or not storage.fugaConfigDuploMotor.macroAtiva then return end
    if not emEstadoDeFuga then return end 

    local labelAtualDoBot = obterLabelAtualDoCaveBot()
    local alvoReativar = tostring(storage.fugaConfigDuploMotor.labelReativar or "check"):lower():gsub("^%s*(.-)%s*$", "%1")
    local alvoAtivar = tostring(storage.fugaConfigDuploMotor.labelAtivarMonit or "start"):lower():gsub("^%s*(.-)%s*$", "%1")

    local resetarEstadoVisual = false

    if acionarResetManualImediato then
        resetarEstadoVisual = true
    end

    local segundosPassados = os.time() - tempoInicioFuga
    local limiteSegundos = tonumber(storage.fugaConfigDuploMotor.tempoAutoVoltarSegundos) or 15
    if segundosPassados >= limiteSegundos then
        resetarEstadoVisual = true
    end

    if storage.fugaConfigDuploMotor.reativarPorLabel and labelAtualDoBot == alvoReativar then
        resetarEstadoVisual = true
    end

    if labelAtualDoBot == alvoAtivar then
        resetarEstadoVisual = true
    end

    if resetarEstadoVisual then
        emEstadoDeFuga = false
        monitoramentoAtivo = true
        dispararFugaPorMensagem = false
        acionarResetManualImediato = false 
        
        if CaveBot.changeLabel then
            CaveBot.changeLabel(storage.fugaConfigDuploMotor.labelAtivarMonit or "start")
        elseif CaveBot.gotoLabel then
            CaveBot.gotoLabel(storage.fugaConfigDuploMotor.labelAtivarMonit or "start")
        end
    end
end)

function forcamentoDoResetFugaSistema()
    if emEstadoDeFuga then
        acionarResetManualImediato = true
    end
end
local campoSendoEditadoAtualmente = ""

function abrirEditorPopUp(chaveStorage, rotuloInformacao)
    campoSendoEditadoAtualmente = chaveStorage
    editWindow:setText("Editar: " .. rotuloInformacao)
    editWindow.lblInfo:setText("Digite o novo valor para " .. rotuloInformacao .. ":")
    local valorAtual = tostring(storage.fugaConfigDuploMotor[chaveStorage] or "")
    editWindow.txtEntrada:setText(valorAtual)
    editWindow:show()
    editWindow:raise()
    editWindow:focus()
    editWindow.txtEntrada:focus()
end

function updateFugaUI()
    if not storage.fugaConfigDuploMotor or not fugaWindow then return end
    
    fugaWindow.btnLabelAtivarMonit:setText("Label Ativar Monit: " .. (storage.fugaConfigDuploMotor.labelAtivarMonit or "start"))
    fugaWindow.btnLabelDestino:setText("Label Fuga: " .. (storage.fugaConfigDuploMotor.labelDestino or "fugir"))
    fugaWindow.btnLabelReativar:setText("Label Destravar: " .. (storage.fugaConfigDuploMotor.labelReativar or "check"))
    fugaWindow.btnTempoAutoVoltar:setText("Tempo Auto Voltar: " .. tostring(storage.fugaConfigDuploMotor.tempoAutoVoltarSegundos or 15) .. "s")
    fugaWindow.btnPlayers:setText("Minimo Players: " .. tostring(storage.fugaConfigDuploMotor.minimoPlayers or 2))
    fugaWindow.btnIDMW:setText("ID Magic Wall: " .. (storage.fugaConfigDuploMotor.idMW or "2128"))
    fugaWindow.btnIDGrav:setText("ID Wild Growth: " .. (storage.fugaConfigDuploMotor.idGrav or "3156"))
    
    local olheiroExibir = storage.fugaConfigDuploMotor.nomeOlheiro or "Nome do Olheiro"
    local alertaExibir = storage.fugaConfigDuploMotor.textoAlerta or "pk"
    fugaWindow.btnOlheiro:setText("Olheiro: " .. olheiroExibir)
    fugaWindow.btnAlerta:setText("Palavra Alerta: " .. alertaExibir)
    
    fugaWindow.swMW:setOn(storage.fugaConfigDuploMotor.fugaPorMW)
    fugaWindow.swMW:setText(storage.fugaConfigDuploMotor.fugaPorMW and "Fuga por MW: LIGADA" or "Fuga por MW: DESLIGADA")
    
    fugaWindow.swGrav:setOn(storage.fugaConfigDuploMotor.fugaPorGrav)
    fugaWindow.swGrav:setText(storage.fugaConfigDuploMotor.fugaPorGrav and "Fuga por Grav: LIGADA" or "Fuga por Grav: DESLIGADA")
    
    fugaWindow.swMsg:setOn(storage.fugaConfigDuploMotor.fugaPorMsg)
    fugaWindow.swMsg:setText(storage.fugaConfigDuploMotor.fugaPorMsg and "Fuga por Msg: LIGADA" or "Fuga por Msg: DESLIGADA")
    
    fugaWindow.swManual:setOn(storage.fugaConfigDuploMotor.monitManual)
    fugaWindow.swManual:setText(storage.fugaConfigDuploMotor.monitManual and "Monitoramento Manual: ON" or "Monitoramento Manual: OFF")
    
    botoesFugaUI.btnLigaMacroFugir:setOn(storage.fugaConfigDuploMotor.macroAtiva)
    botoesFugaUI.btnLigaMacroFugir:setText(storage.fugaConfigDuploMotor.macroAtiva and "Fuga: ON" or "Fuga: OFF")

    if not storage.fugaConfigDuploMotor.macroAtiva then
        fugaWindow.lblStatusSistema:setText("Status: DESLIGADO (Macro Off)")
        fugaWindow.lblStatusSistema:setColor("white")
        fugaWindow.lblStatusMonit:setText("Sensor: INATIVO")
        fugaWindow.lblStatusMonit:setColor("white")
    elseif emEstadoDeFuga then
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

botoesFugaUI.btnLigaMacroFugir.onClick = function() storage.fugaConfigDuploMotor.macroAtiva = not storage.fugaConfigDuploMotor.macroAtiva updateFugaUI() end
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

fugaWindow.btnResetManualFuga.onClick = function()
    forcamentoDoResetFugaSistema()
    updateFugaUI()
end

-- EVENTO COMPLETO DO LINK: Abre a URL nativamente pelo motor grafico do client
fugaWindow.btnAcessarUrl.onClick = function()
    local urlDestino = "https://discord.gg/R4WNZwG2pN" -- Cole seu link ou site aqui dentro
    if g_signals and g_signals.openUrl then
        g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then
        g_platform.openUrl(urlDestino)
    end
end

fugaWindow.swMW.onClick = function() storage.fugaConfigDuploMotor.fugaPorMW = not storage.fugaConfigDuploMotor.fugaPorMW updateFugaUI() end
fugaWindow.swGrav.onClick = function() storage.fugaConfigDuploMotor.fugaPorGrav = not storage.fugaConfigDuploMotor.fugaPorGrav updateFugaUI() end
fugaWindow.swMsg.onClick = function() storage.fugaConfigDuploMotor.fugaPorMsg = not storage.fugaConfigDuploMotor.fugaPorMsg updateFugaUI() end
fugaWindow.swManual.onClick = function() storage.fugaConfigDuploMotor.monitManual = not storage.fugaConfigDuploMotor.monitManual updateFugaUI() end
fugaWindow.closeBtn.onClick = function() fugaWindow:hide() end

editWindow.btnCancelar.onClick = function() editWindow:hide() end
editWindow.btnConfirmar.onClick = function()
    local textoDigitado = editWindow.txtEntrada:getText()
    if campoSendoEditadoAtualmente ~= "" then
        if campoSendoEditadoAtualmente == "minimoPlayers" or campoSendoEditadoAtualmente == "tempoAutoVoltarSegundos" then 
            storage.fugaConfigDuploMotor[campoSendoEditadoAtualmente] = tonumber(textoDigitado) or 15
        else 
            storage.fugaConfigDuploMotor[campoSendoEditadoAtualmente] = textoDigitado 
        end
    end
    editWindow:hide()
    updateFugaUI()
end

macro(100, function()
    if botoesFugaUI and storage.fugaConfigDuploMotor then
        botoesFugaUI.btnLigaMacroFugir:setOn(storage.fugaConfigDuploMotor.macroAtiva)
    end
    
    if fugaWindow and fugaWindow:isVisible() and fugaWindow.lblMarcaDagua then
        local pulse = math.abs(math.sin(os.clock() * 4))
        local greenBlueBrilho = math.floor(255 * (1 - pulse))
        fugaWindow.lblMarcaDagua:setColor(string.format("#FF%02X%02X", greenBlueBrilho, greenBlueBrilho))
    end
    
    updateFugaUI()
end)

updateFugaUI()

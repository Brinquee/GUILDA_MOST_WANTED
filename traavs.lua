setDefaultTab("GUILD")

local panelName = "travaMostWanted"
if type(storage[panelName]) ~= "table" then
    storage[panelName] = {
        height = 140,
        macrosMarcados = {
            antipush = true, configs = true, potguild = true, filtro = true,
            rainbow = true, skills = true, bola = true, combo = true,
            energyssa = true, stamina = true, healing = true, exiva = true,
            magias = true, fps = true, abrirbag = true
        }
    }
end

local config = storage[panelName]

-- =============================================================================
-- [BLOCO 1] CONFIGURACOES DE LINKS E SEGURANCA
-- =============================================================================
local LINK_INSTAGRAM = "https://www.instagram.com/brinquescriptsgamer?igsh=dXhhN2MxNWhxMm9m"
local LINK_WHATSAPP  = "https://chat.whatsapp.com/D4WHVuAy41t6uQ6QZ3ibtR"
local LINK_DISCORD   = "https://discord.gg"
local LINK_YOUTUBE   = "https://youtube.com"

local CHAR_VALIDADOR = "Gerente Most"
local COMANDO_LOG     = "!sincronizar"
local CHAVE_ASSINATURA_INTERNA = "MOST_WANTED_SECRET_KEY_2026"

local script_path = "/scripts_storage/"
local path_licenca_json = script_path .. player:getName() .. '_lic.json'

if not modules._G.g_resources.fileExists(script_path) then
    modules._G.g_resources.makeDir(script_path)
end

local function gerarAssinaturaDigital(dadosTexto)
    local hash = 0
    local stringCombinada = dadosTexto .. player:getName() .. CHAVE_ASSINATURA_INTERNA
    for i = 1, #stringCombinada do
        hash = (hash * 31 + string.byte(stringCombinada, i)) % 100000000
    end
    return tostring(hash)
end

local function colocarCifraNoTexto(dadosLimpos)
    local resultado = ""
    for i = 1, #dadosLimpos do resultado = resultado .. string.format("%02x", string.byte(dadosLimpos, i) + 5) end
    return resultado
end

local function tirarCifraDoTexto(dadosEscondidos)
    if not dadosEscondidos or #dadosEscondidos % 2 ~= 0 then return "{}" end
    local resultado = ""
    for i = 1, #dadosEscondidos, 2 do
        local c = tonumber(dadosEscondidos:sub(i, i+1), 16)
        if c then resultado = resultado .. string.char(c - 5) end
    end
    return resultado
end
local widgetRaizDoJogo = g_ui.getRootWidget()
-- JANELA 1: STATUS DA LICENCA
local setupTravaWindow = setupUI([[
MainWindow
  id: janelaLicenca
  !text: tr('Status da Licenca - Mercenarios Celestiais')
  size: 350 200
  @onEscape: self:hide()

  Label
    id: lblStatus
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 12
    margin-left: 12
    text: Status: Carregando...
    font: verdana-11px-rounded

  Label
    id: lblDataInicio
    anchors.top: lblStatus.bottom
    anchors.left: parent.left
    margin-top: 10
    margin-left: 12
    text: Data da Sincronizacao: --/--/----
    font: verdana-11px-rounded
    color: #bdbdbd

  Label
    id: lblDataFinal
    anchors.top: lblDataInicio.bottom
    anchors.left: parent.left
    margin-top: 10
    margin-left: 12
    text: Data de Expiracao: --/--/----
    font: verdana-11px-rounded
    color: #44ff44

  Label
    id: lblTempoRestante
    anchors.top: lblDataFinal.bottom
    anchors.left: parent.left
    margin-top: 10
    margin-left: 12
    text: Tempo Restante: Calculando...
    font: verdana-11px-rounded
    color: #e6bc22

  HorizontalSeparator
    id: sep
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: closeButton.top
    margin-bottom: 8

  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 45 21
    @onClick: self:getParent():hide()
]], widgetRaizDoJogo)
setupTravaWindow:hide()

-- JANELA 2 OFICIAL DEFINITIVA: CALIBRAGEM RESTRITA DE CLIQUES (SISTEMA ANCHORS.CENTERIN)
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaEscolhaMacros\n" ..
"  size: 560 380\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoCustomCelestiais\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000055\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: listaScroll\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: barraRolagem.left\n" ..
"    anchors.bottom: sepInf.top\n" ..
"    margin-top: 10\n" ..
"    margin-left: 10\n" ..
"    margin-right: 2\n" ..
"    margin-bottom: 5\n" ..
"    vertical-scrollbar: barraRolagem\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: barraRolagem\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: sepInf.top\n" ..
"    anchors.right: lblRedesTitulo.left\n" ..
"    margin-top: 10\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 5\n" ..
"    step: 20\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblRedesTitulo\n" ..
"    text: -- REDES SOCIAIS DA GUILDA --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #00bfff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 20\n" ..
"    margin-left: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoInsta\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblRedesTitulo.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -65\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnInstagram\n" ..
"    text: Acessar Instagram\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoInsta\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoWhats\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoInsta.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -165\n" ..
"    margin-left: 30\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnWhatsApp\n" ..
"    text: Grupo do WhatsApp\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoWhats\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoDiscord\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoWhats.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -165\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnDiscord\n" ..
"    text: Servidor do Discord\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoDiscord\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoYoutube\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoDiscord.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -165\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnYouTube\n" ..
"    text: Canal do YouTube\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoYoutube\n" ..
"\n" ..
"  HorizontalSeparator\n" ..
"    id: sepInf\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: closeBtn.top\n" ..
"    margin-bottom: 8\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 60 20\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 15\n" ..
"    @onClick: self:getParent():hide()\n"

local setupMacrosWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
setupMacrosWindow:hide()

-- =============================================================================
-- [BLOCO 3] FILTRO AUTO-INJETOR E PROTETOR DE SEPARADORES
-- =============================================================================
local pastaImg = "/bot/CUSTOM_PREMIUM/imagens/"
local mapeamentoBotoesImagens = {
    { widget = setupMacrosWindow.imgFundoInsta,   file = "butaoazulverme.png" },
    { widget = setupMacrosWindow.imgFundoWhats,   file = "butaoazulverme.png" },
    { widget = setupMacrosWindow.imgFundoDiscord, file = "butaoazulverme.png" },
    { widget = setupMacrosWindow.imgFundoYoutube, file = "butaoazulverme.png" }
}

for _, itemBtn in ipairs(mapeamentoBotoesImagens) do
    local caminhoCompletoFoto = pastaImg .. itemBtn.file
    if not g_resources.fileExists(caminhoCompletoFoto) then
        itemBtn.widget:setImageSource("")
        itemBtn.widget:setBackgroundColor("#2f2f2f")
    end
end

-- =============================================================================
-- [BLOCO 4] REDIRECIONAMENTO DE LINKS REAIS E COMPONENTES DA LISTA
-- =============================================================================
local function abrirLinkNoNavegadorReal(urlDestino)
    if g_signals and g_signals.openUrl then
        g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then
        g_platform.openUrl(urlDestino)
    else
        print(">>> [MERCENARIOS] Link para copiar: " .. urlDestino)
    end
end

setupMacrosWindow.btnInstagram.onClick = function() abrirLinkNoNavegadorReal(LINK_INSTAGRAM) end
setupMacrosWindow.btnWhatsApp.onClick  = function() abrirLinkNoNavegadorReal(LINK_WHATSAPP) end
setupMacrosWindow.btnDiscord.onClick   = function() abrirLinkNoNavegadorReal(LINK_DISCORD) end
setupMacrosWindow.btnYouTube.onClick   = function() abrirLinkNoNavegadorReal(LINK_YOUTUBE) end

local uiTravaAba = nil
local function renderizarBotoesDaAbaLateral(licencaAtiva)
    if uiTravaAba then uiTravaAba:destroy() end
    if licencaAtiva then
        uiTravaAba = setupUI([[
Panel
  height: 40
  Button
    id: btnChecar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 2
    height: 17
    text: Ver Licenca
    font: verdana-11px-rounded
  Button
    id: btnMacrosMenu
    anchors.top: parent.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 2
    height: 17
    text: Escolher Macros
    font: verdana-11px-rounded
  ]], getTab("GUILD"))

        uiTravaAba.btnChecar.onClick = function()
            if setupTravaWindow:isVisible() then setupTravaWindow:hide() else setupTravaWindow:show() setupTravaWindow:raise() setupTravaWindow:focus() atualizarTextosDoPainel() end
        end
        uiTravaAba.btnMacrosMenu.onClick = function()
            if setupMacrosWindow:isVisible() then setupMacrosWindow:hide() else setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
        end
    else
        uiTravaAba = setupUI([[
Panel
  height: 20
  Button
    id: btnChecar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Ver Status da Licenca
    font: verdana-11px-rounded
  ]], getTab("GUILD"))

        uiTravaAba.btnChecar.onClick = function()
            if setupTravaWindow:isVisible() then setupTravaWindow:hide() else setupTravaWindow:show() setupTravaWindow:raise() setupTravaWindow:focus() atualizarTextosDoPainel() end
        end
        setupMacrosWindow:hide()
    end
end

local MAPA_MACROS_GUILDA = {
    -- ==========================================
    -- MACROS COM PRIORIDADE (HEALING)
    -- ==========================================
    { nome = "HEALING BRQ",          key = "healingBRQ",         cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/healingBRQ.lua" },
    { nome = "OPEN BAG MAIN BRQ",    key = "openbagmainBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagmainBRQ.lua" },
    { nome = "BLESSED HP/MP BRQ",    key = "blessedhpmpBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/blessed_hpmpBRQ.lua" },
    { nome = "ENEGY-SSA-MIGHT BRQ",  key = "energyssamightBRQ",  cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/enegy_ssa_mightBRQ.lua" },
	{ nome = "FILTRO BATTLE BRQ",    key = "filtrobatleBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Painel.lua" },
    { nome = "POT GUILD BRQ",        key = "potguildBRQ",        cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/potguildBRQ.lua" },
    { nome = "BUFF BRQ",             key = "BRQbuff",            cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/BRQ_buff_v1.0.lua" },
	{ nome = "STAMINA BRQ",          key = "staminaBRQ",         cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/staminaBRQ.lua" },


    -- ==========================================
    -- MACROS SEM PRIORIDADE (CAVE/TARGET)
    -- ==========================================
    { nome = "FUGA COMPLETA BRQ",    key = "fugacompletaBRQ",    cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fugacompletaBRQ.lua" },
    { nome = "OLHEIRO_BRQ",          key = "olheiroBRQ",         cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/olheiro_BRQ1.0.lua" },
    { nome = "COMBO LIDER BRQ",      key = "comboliderBRQ",      cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/comboliderBRQ.lua" },
    { nome = "OUTFIT VISUAL BRQ",    key = "outfitvisualBRQ",    cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/outfitvisualBRQ.lua" },
    { nome = "ATACKTODOS_BRQ",       key = "atacatodosBRQ",      cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/atacatodosBRQ.lua" },
    { nome = "TARGET PLAY OFF",      key = "targetplayoffBRQ",   cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/targetplayoffBRQ.lua" },
    -- ==========================================
    -- MACROS DA AUTOMATICO GUILDA (WAR)
    -- ==========================================
    { nome = "3 PUSHE BRQ",          key = "3pusheBRQ",          cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/3pusheBRQ.lua" },
    { nome = "ANTPUSHE MOUSE-PE BRQ", key = "antpushemousepeBRQ", cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Dropar_item_na_posicao_do_mouseBRQ.lua" },
    { nome = "MW NO PE",             key = "MWPE",               cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/mwnopeBRQ.lua" },
    { nome = "PUXAR AO REDOR BRQ",   key = "puxaraoredorBRQ",    cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/puxaraoredorBRQ.lua" },
    { nome = "EXIVA BRQ",            key = "exivaBRQ",           cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/exivaBRQ.lua" },

    -- ==========================================
    -- MACROS EXTRAS (EXTRAS)
    -- ==========================================
	{ nome = "FILTRO BATTLE BRQ",    key = "filtrobatleBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/filtrobatleBRQ" },
	{ nome = "SKILLS BRQ",           key = "skillsBRQ",          cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/skillsBRQ.lua" },
    { nome = "FPS BRQ",              key = "fpsBRQ",             cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fpsBRQ.lua" },
    { nome = "RAINBOW COLOR BRQ",    key = "rainbowcolorBRQ",    cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/rainbowcolorBRQ.lua" },
    { nome = "HUND COLOR BRQ",       key = "hundcolorBRQ",       cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/hundcolorBRQ.lua" },
    { nome = "OPEN BAG CHEIA BRQ",   key = "openbagcheiaBRQ",    cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagcheiaBRQ.lua" },
	{ nome = "MAGIAS S/PK BRQ",      key = "magiasempkBRQ",      cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/magiasempkBRQ.lua" }
}


local ORDEM_CATEGORIAS = { "HEALING", "CAVE/TARGET", "WAR", "EXTRAS" }
local CORES_CATEGORIAS = { ["HEALING"] = "#44ff44", ["CAVE/TARGET"] = "#00bfff", ["WAR"] = "#ff4444", ["EXTRAS"] = "#e6bc22" }

for _, nomeCat in ipairs(ORDEM_CATEGORIAS) do
    local div = g_ui.createWidget("Label", setupMacrosWindow.listaScroll)
    div:setText("-- " .. nomeCat .. " --")
    div:setFont("verdana-11px-rounded")
    div:setColor(CORES_CATEGORIAS[nomeCat])
    div:setMarginTop(5)
    div:setMarginBottom(2)

    for _, item in ipairs(MAPA_MACROS_GUILDA) do
        if item.cat == nomeCat then
            if config.macrosMarcados[item.key] == nil then config.macrosMarcados[item.key] = true end
            local box = g_ui.createWidget("CheckBox", setupMacrosWindow.listaScroll)
            box:setText(item.nome)
            box:setFont("verdana-11px-rounded")
            box:setHeight(16)
            box:setChecked(config.macrosMarcados[item.key] == true)
            box.onClick = function(w)
                local val = not w:isChecked()
                w:setChecked(val)
                config.macrosMarcados[item.key] = val
            end
        end
    end
end

-- =============================================================================
-- [BLOCO 5] EXECUTOR DE FILA HTTP E SINCRO DE LICENCA
-- =============================================================================
local loteJaEstaSendoBaixado = false
local function executarFilaCustomizadaHTTP(indice)
    if indice == 1 then if loteJaEstaSendoBaixado then return end loteJaEstaSendoBaixado = true end
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then print("[Baixador] Todos os scripts ativos injetados com sucesso."); loteJaEstaSendoBaixado = false return end
    if config.macrosMarcados[macroAlvo.key] == true then
        HTTP.get(macroAlvo.url .. "?v=" .. os.time(), function(content, err)
            if not err then
                if macroAlvo.url:find("PotGuild.lua") then if partyPotUI then partyPotUI:destroy() partyPotUI = nil end if ppWindow then ppWindow:destroy() ppWindow = nil end end
                local script, syntaxErr = loadstring(content)
                if script then pcall(script) else print("Erro slot: " .. tostring(syntaxErr)) end
            end
            schedule(1000, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        executarFilaCustomizadaHTTP(indice + 1)
    end
end
function atualizarTextosDoPainel()
    if not setupTravaWindow:isVisible() then return end
    if not modules._G.g_resources.fileExists(path_licenca_json) then return end
    local txt = tirarCifraDoTexto(modules._G.g_resources.readFileContents(path_licenca_json):trim())
    local status, dados = pcall(json.decode, txt)
    if status and dados and dados.expiracao then
        local restante = dados.expiracao - os.time()
        setupTravaWindow.lblDataInicio:setText("Data de Sincronizacao: " .. (dados.dataSinc or "--/--/----"))
        setupTravaWindow.lblDataFinal:setText("Data de Expiracao: " .. os.date("%d/%m/%Y", dados.expiracao))
        if restante > 0 then
            setupTravaWindow.lblStatus:setText("Status: LICENCA ATIVA")
            setupTravaWindow.lblStatus:setColor("#44ff44")
            setupTravaWindow.lblTempoRestante:setText(string.format("Tempo Restante: %d dias e %d horas", math.floor(restante / 86400), math.floor((restante % 86400) / 3600)))
        else
            setupTravaWindow.lblStatus:setText("Status: EXPIRADO / TRAVADO")
            setupTravaWindow.lblStatus:setColor("#ff4444")
            setupTravaWindow.lblTempoRestante:setText("Tempo Restante: 0 dias (Bloqueado)")
        end
    end
end

local function checarLicencaValidaComStatus()
    if not modules._G.g_resources.fileExists(path_licenca_json) then return false end
    local txt = tirarCifraDoTexto(modules._G.g_resources.readFileContents(path_licenca_json):trim())
    local status, dados = pcall(json.decode, txt)
    if status and dados and dados.expiracao and dados.assinatura then
        local checagemTexto = tostring(dados.expiracao) .. tostring(dados.status) .. tostring(dados.dataSinc)
        if dados.assinatura ~= gerarAssinaturaDigital(checagemTexto) then return false end
        if dados.status == "bloqueado" or os.time() >= dados.expiracao then return false end
        return true
    end
    return false
end

local function converterDataParaTimestamp(dataTexto)
    local dia, mes, ano = dataTexto:match("(%d+)/(%d+)/(%d+)")
    if dia and mes and ano then return os.time({year = tonumber(ano), month = tonumber(mes), day = tonumber(dia), hour = 23, min = 59, sec = 59}) end
    return nil
end

local function salvarNovaLicencaCriptografada(timestampFinal, statusString)
    local dataHoje = os.date("%d/%m/%Y %H:%M:%S")
    local textoParaAssinar = tostring(timestampFinal) .. tostring(statusString) .. tostring(dataHoje)
    local assinaturaValida = gerarAssinaturaDigital(textoParaAssinar)
    local jsonString = json.encode({ expiracao = timestampFinal, status = statusString, dataSinc = dataHoje, signature = assinaturaValida, assinatura = assinaturaValida })
    pcall(function() modules._G.g_resources.writeFileContents(path_licenca_json, colocarCifraNoTexto(jsonString)) end)
end

macro(600000, function() 
    local valido = checarLicencaValidaComStatus()
    renderizarBotoesDaAbaLateral(valido)
    if not valido then reload() end 
end)

onTalk(function(name, level, mode, text, channelId)
    if name == CHAR_VALIDADOR and text:lower():trim():find("licenca acaba dia") then
        local dataCaptured = text:match("(%d+/%d+/%d+)")
        if dataCaptured then
            local timestampFinal = converterDataParaTimestamp(dataCaptured)
            if timestampFinal then
                salvarNovaLicencaCriptografada(timestampFinal, "ativo")
                renderizarBotoesDaAbaLateral(true)
                executarFilaCustomizadaHTTP(1)
            end
        end
    end
end)

onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

schedule(2000, function() sayPrivate(CHAR_VALIDADOR, COMANDO_LOG) end)

local estaValidoNoArranque = checarLicencaValidaComStatus()
renderizarBotoesDaAbaLateral(estaValidoNoArranque)

if estaValidoNoArranque then
    print("[Seguranca] Licenca ativa. Carregando macros via cache...")
    executarFilaCustomizadaHTTP(1)
else
    print(">>> [SEGURANÇA] Licenca expirada ou pendente. Aguardando...")
end

setDefaultTab("main")

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

-- CONFIGURAÇÕES DE PROTEÇÃO REMOTA DA GUILDA
local CHAR_VALIDADOR = "Gerente Most"
local COMANDO_LOG     = "!sincronizar"
local CHAVE_ASSINATURA_INTERNA = "MOST_WANTED_SECRET_KEY_2026"

local script_path = "/scripts_storage/"
local path_licenca_json = script_path .. player:getName() .. '_lic.json'

if not modules._G.g_resources.fileExists(script_path) then
    modules._G.g_resources.makeDir(script_path)
end

-- Assinatura digital que amarra a licença ao Nome do Personagem (Anti-Vazamento)
local function gerarAssinaturaDigital(dadosTexto)
    local hash = 0
    local stringCombinada = dadosTexto .. player:getName() .. CHAVE_ASSINATURA_INTERNA
    for i = 1, #stringCombinada do
        hash = (hash * 31 + string.byte(stringCombinada, i)) % 100000000
    end
    return tostring(hash)
end

-- Criptografia Hexadecimal para ocultar os dados no Bloco de Notas
local function embaralharTexto(dadosLimpos)
    local resultado = ""
    for i = 1, #dadosLimpos do
        resultado = resultado .. string.format("%02x", string.byte(dadosLimpos, i) + 5)
    end
    return resultado
end

local function desembaralharTexto(dadosEscondidos)
    if not dadosEscondidos or #dadosEscondidos % 2 ~= 0 then return "{}" end
    local resultado = ""
    for i = 1, #dadosEscondidos, 2 do
        local c = tonumber(dadosEscondidos:sub(i, i+1), 16)
        if c then resultado = resultado .. string.char(c - 5) end
    end
    return resultado
end
local widgetRaizDoJogo = g_ui.getRootWidget()

-- JANELA 1: STATUS DA LICENÇA
local setupTravaWindow = setupUI([[
MainWindow
  id: janelaLicenca
  !text: tr('Status da Licenca - Most Wanted')
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

-- JANELA 2: PAINEL DE MARCAÇÃO COM SCROLL INFINITO
local setupMacrosWindow = setupUI([[
MainWindow
  id: janelaEscolhaMacros
  !text: tr('Painel de Macros - Most Wanted')
  size: 280 380
  @onEscape: self:hide()

  ScrollablePanel
    id: listaScroll
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: barraRolagem.left
    anchors.bottom: sepInf.top
    margin-top: 10
    margin-left: 10
    margin-right: 2
    margin-bottom: 5
    vertical-scrollbar: barraRolagem
    layout:
      type: verticalBox
      spacing: 6

  VerticalScrollBar
    id: barraRolagem
    anchors.top: parent.top
    anchors.bottom: sepInf.top
    anchors.right: parent.right
    margin-top: 10
    margin-bottom: 5
    margin-right: 10
    step: 14
    pixels-scroll: true

  HorizontalSeparator
    id: sepInf
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: closeBtn.top
    margin-bottom: 8

  Button
    id: closeBtn
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    size: 60 20
    margin-bottom: 5
    margin-right: 10
    @onClick: self:getParent():hide()
]], widgetRaizDoJogo)
setupMacrosWindow:hide()

-- Painel Dinâmico da Aba Lateral
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
  ]], getTab("main"))

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
  ]], getTab("main"))

        uiTravaAba.btnChecar.onClick = function()
            if setupTravaWindow:isVisible() then setupTravaWindow:hide() else setupTravaWindow:show() setupTravaWindow:raise() setupTravaWindow:focus() atualizarTextosDoPainel() end
        end
        setupMacrosWindow:hide()
    end
end
local MAPA_MACROS_GUILDA = {

											-- MACROS COM PRIORIDADE --

    { nome = "HEALING BRQ",      key = "healingBRQ",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/healingBRQ.lua" },
	
    { nome = "OPEN BAG MAIN BRQ",key = "openbagmainBRQ",    url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagmainBRQ.lua" },
	
	{ nome = "BLESSED HP/MP BRQ",key = "blessedhpmpBRQ",    url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/blessed_hpmpBRQ.lua" },
	
    { nome = "ENEGY-SSA-MIGHT BRQ",       key = "energyssamightBRQ",    url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/enegy_ssa_mightBRQ.lua" },
	
    { nome = "POT GUILD BRQ",        key = "potguildBRQ",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/potguildBRQ.lua" },
	
	{ nome = "BUFF BRQ",    key = "BRQbuff",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/BRQ_buff_v1.0.lua" },
	
	{ nome = "PUXAR AO REDOR BRQ",        key = "puxaraoredorBRQ",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/puxaraoredorBRQ.lua" },
	
	{ nome = "FILTRO BATTLE BRQ",    key = "filtrobatleBRQ",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/filtrobatleBRQ.lua" },
											-- MACROS SEM PRIORIDADE --

	


    { nome = "SKILLS BRQ",           key = "skillsBRQ",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/skillsBRQ.lua" },
	
    { nome = "RAINBOW COLOR BRQ",    key = "rainbowcolorBRQ",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/rainbowcolorBRQ.lua" },
	
    { nome = "COMBO LIDER BRQ",      key = "comboliderBRQ",        url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/comboliderBRQ.lua" },
	
											-- MACROS DA AUTOMATICO GUILDA --
	{ nome = "3 PUSHE BRQ",             key = "3pusheBRQ",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/3pusheBRQ.lua" },
												
    { nome = "STAMINA BRQ",          key = "staminaBRQ",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/staminaBRQ.lua" },
	
    { nome = "EXIVA BRQ",            key = "exivaBRQ",        url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/exivaBRQ.lua" },
	
    { nome = "MAGIAS S/PK BRQ",    key = "magiasempkBRQ",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/magiasempkBRQ.lua" },
	
    { nome = "FPS BRQ",              key = "fpsBRQ",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fpsBRQ.lua" },
	
	{ nome = "OUTFIT VISUAL BRQ",   key = "outfitvisualBRQ",      url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/outfitvisualBRQ.lua" },
	
    { nome = "ANTPUSHE MOUSE-PE BRQ",              key = "antpushemousepeBRQ",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Dropar_item_na_posicao_do_mouseBRQ.lua" },
	
    { nome = "MW NO PE",              key = "MWPE",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/mwnopeBRQ.lua" },
	
	{ nome = "TARGET PLAY OFF",              key = "targetplayoffBRQ",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/targetplayoffBRQ.lua" },
	
	{ nome = "FUGA COMPLETA BRQ",              key = "fugacompletaBRQ",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fugacompletaBRQ.lua" },
	
	{ nome = "OLHEIRO_BRQ",              key = "olheiroBRQ",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/olheiro_BRQ1.0.lua" },

	{ nome = "ATACKTODOS_BRQ",              key = "atacatodosBRQ",          url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/atacatodosBRQ.lua" },
	
	{ nome = "OPEN BAG CHEIA BRQ",key = "openbagcheiaBRQ",    url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagcheiaBRQ.lua" },

	{ nome = "HUND COLOR BRQ",key = "hundcolorBRQ",    url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/hundcolorBRQ.lua" }

}

-- Desenha as caixas cinzas no painel
for _, item in ipairs(MAPA_MACROS_GUILDA) do
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
        print("[Trava] Preferenca alterada para " .. item.nome .. ": " .. (val and "LIGADO" or "DESLIGADO"))
    end
end

-- VARIÁVEL DE BLINDAGEM CONTRA DOWNLOAD DUPLO
local loteJaEstaSendoBaixado = false

local function executarFilaCustomizadaHTTP(indice)
    -- Tranca o motor no primeiro slot para não deixar outra requisição entrar em paralelo
    if indice == 1 then
        if loteJaEstaSendoBaixado then 
            print("[Seguranca] Alerta: Uma fila de download ja esta ativa. Ignorando chamada duplicada.")
            return 
        end
        loteJaEstaSendoBaixado = true
    end

    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Baixador] Todos os scripts marcados foram injetados com sucesso."); 
        loteJaEstaSendoBaixado = false -- Destranca apenas ao finalizar tudo
        return 
    end
    
    if config.macrosMarcados[macroAlvo.key] == true then
        HTTP.get(macroAlvo.url .. "?v=" .. os.time(), function(content, err)
            if not err then
                if macroAlvo.url:find("PotGuild.lua") then
                    if partyPotUI then partyPotUI:destroy() partyPotUI = nil end
                    if ppWindow then ppWindow:destroy() ppWindow = nil end
                end
                local script, syntaxErr = loadstring(content)
                if script then pcall(script) else print("Erro slot: " .. tostring(syntaxErr)) end
            end
            schedule(1000, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

local function atualizarTextosDoPainel()
    if not setupTravaWindow:isVisible() then return end
    if not modules._G.g_resources.fileExists(path_licenca_json) then return end
    local txt = desembaralharTexto(modules._G.g_resources.readFileContents(path_licenca_json):trim())
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
    local txt = desembaralharTexto(modules._G.g_resources.readFileContents(path_licenca_json):trim())
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
    pcall(function() modules._G.g_resources.writeFileContents(path_licenca_json, embaralharTexto(jsonString)) end)
end

-- Verificador em segundo plano
macro(600000, function() 
    local valido = checarLicencaValidaComStatus()
    renderizarBotoesDaAbaLateral(valido)
    if not valido then reload() end 
end)

-- Interceptador de PM do Gerente Most
onTalk(function(name, level, mode, text, channelId)
    if name == CHAR_VALIDADOR and text:lower():trim():find("licenca acaba dia") then
        local dataCaptured = text:match("(%d+/%d+/%d+)")
        if dataCaptured then
            local timestampFinal = converterDataParaTimestamp(dataCaptured)
            if timestampFinal then
                salvarNovaLicencaCriptografada(timestampFinal, "ativo")
                print(">>> [SEGURANÇA] Sincronizacao remota atualizada em disco!")
                renderizarBotoesDaAbaLateral(true)
                -- Tenta rodar o download. Se o cache já iniciou, a trava da linha 48 barra a duplicada!
                executarFilaCustomizadaHTTP(1)
            end
        end
    end
end)

-- Manda a PM obrigatoriamente
schedule(2000, function() sayPrivate(CHAR_VALIDADOR, COMANDO_LOG) end)

-- IGNIÇÃO DO SISTEMA
local estaValidoNoArranque = checarLicencaValidaComStatus()
renderizarBotoesDaAbaLateral(estaValidoNoArranque)

if estaValidoNoArranque then
    print("[Seguranca] Licenca ativa. Iniciando download automatico via cache...")
    executarFilaCustomizadaHTTP(1)
else
    print(">>> [SEGURANÇA] Licenca expirada ou pendente. Aguardando comunicacao...")
end

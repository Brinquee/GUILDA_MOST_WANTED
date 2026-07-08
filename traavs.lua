-- ========================================================
-- ARQUIVO DO GITHUB: GERENCIADOR DE SCRIPTS + TRAVA DA GUILDA
-- ========================================================

-- 1. CONFIGURAÇÃO DA TRAVA
local CHAR_VALIDADOR = "Gerente Most"
local PALAVRA_CHAVE  = "!liberarMacro"
local SENHA_CORRETA  = "Gu1ld4OtC_2026"
local tempoDeEspera  = 1000 -- Delay de 1 segundo para não bugar

script_bot = {};
local script_path = '/scripts_storage/';
local script_path_json = script_path .. player:getName() .. '.json';
local path_licenca_json = script_path .. player:getName() .. '_lic.json';

setDefaultTab('Main')
local tabName = getTab('Main') or setDefaultTab('Main')
actualVersion = 0.4;

-- CACHE DE MACROS DO SEU SERVIDOR (Links corrigidos com raw.githubusercontent)
script_manager = {
    actualVersion = 0.4,
    _cache = {
        Guilda = {
            ['Pot Guild'] = {
                url = 'https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/Dwo84.lua',
                description = 'Macro de auto potion allies e party pot.',
                author = 'Brinquee', enabled = false
            },
        },
        -- Você pode adicionar as outras categorias aqui (PvP, Healing, Tibia...)
    }
}

-- 2. FUNÇÕES LOGICAS DA LICENÇA
local function formatarTempoRestante(segundos)
    if segundos <= 0 then return "Expirado" end
    local dias = math.floor(segundos / 86400)
    local horas = math.floor((segundos % 86400) / 3600)
    local minutos = math.floor((segundos % 3600) / 60)
    return dias > 0 and string.format("%dd %dh %dm", dias, horas, minutos) or string.format("%dh %dm", horas, minutos)
end

local function obterTempoExpiracaoAtual()
    if not modules._G.g_resources.fileExists(path_licenca_json) then return 0 end
    local txt = modules._G.g_resources.readFileContents(path_licenca_json)
    local status, dados = pcall(json.decode, txt)
    return (status and dados and dados.expiracao) and dados.expiracao or 0
end

local function checarLicencaValidaComStatus()
    if not modules._G.g_resources.fileExists(path_licenca_json) then return false end
    local txt = modules._G.g_resources.readFileContents(path_licenca_json)
    local status, dados = pcall(json.decode, txt)
    if status and dados then
        if dados.status == "bloqueado" then return false end
        if dados.expiracao and os.time() < dados.expiracao then return true end
    end
    return false
end

local function salvarNovaLicencaComStatus()
    local expiracaoAtual = obterTempoExpiracaoAtual()
    local tempoAdicional = 604800
    local novaExpiracao = expiracaoAtual > os.time() and (expiracaoAtual + tempoAdicional) or (os.time() + tempoAdicional)
    pcall(function() modules._G.g_resources.writeFileContents(path_licenca_json, json.encode({ expiracao = novaExpiracao, status = "ativo" }, 4)) end)
end

local function obterStatusInterno()
    if not modules._G.g_resources.fileExists(path_licenca_json) then return "inativo" end
    local txt = modules._G.g_resources.readFileContents(path_licenca_json)
    local status, dados = pcall(json.decode, txt)
    return (status and dados and dados.status) and dados.status or "ativo"
end

local function atualizarCronometroVisual()
    local label = modules._G.rootWidget:recursiveGetChildById("labelCronometroG")
    if not label then return end
    local expiracao = obterTempoExpiracaoAtual()
    local status = obterStatusInterno()
    local restante = expiracao - os.time()
    
    if status == "bloqueado" then label:setText("Licenca: PAUSADA") label:setColor("orange")
    elseif restante > 0 then label:setText("Licenca: " .. formatarTempoRestante(restante)) label:setColor("green")
    else label:setText("Licenca: EXPIRADA") label:setColor("red") end
end

-- 3. MOTOR DE FILA E COMPILAÇÃO (Injeta em ordem respeitando o delay)
local filaDeDownload = {}
local function processarFilaSequencial(index)
    if not filaDeDownload[index] then
        print("[Manager] Todos os macros selecionados foram carregados")
        return
    end
    
    local urlMacro = filaDeDownload[index]
    local urlComAntiCache = urlMacro .. "?v=" .. os.time()
    
    print("[Manager] Baixando macro sequencial [" .. index .. "]...")
    
    HTTP.get(urlComAntiCache, function(content, error)
        if content then
            if urlMacro:find("PotGuild.lua") then
                if partyPotUI then partyPotUI:destroy() partyPotUI = nil end
                if ppWindow then ppWindow:destroy() ppWindow = nil end
            end
            local script, err = loadstring(content)
            if script then pcall(script) end
        end
        
        -- Aguarda o delay controlado de 1 segundo antes de chamar o próximo macro ativo
        schedule(tempoDeEspera, function()
            processarFilaSequencial(index + 1)
        end)
    end)
end

-- Carrega lote de scripts ativos salvos no JSON
script_bot.onLoading = function()
    if not checarLicencaValidaComStatus() then return end
    filaDeDownload = {}
    
    for categoryName, categoryList in pairs(script_manager._cache) do
        for key, value in pairs(categoryList) do
            if value.enabled then
                table.insert(filaDeDownload, value.url)
            end
        end
    end
    
    if #filaDeDownload > 0 then
        processarFilaSequencial(1)
    end
end

-- Funções de persistência JSON da UI pública
script_bot.readScripts = function()
    if modules._G.g_resources.fileExists(script_path_json) then
        local content = modules._G.g_resources.readFileContents(script_path_json);
        local status, result = pcall(json.decode, content);
        if status then script_manager = result else script_bot.saveScripts() end
    else script_bot.saveScripts() end
end

script_bot.saveScripts = function()
    pcall(function() modules._G.g_resources.writeFileContents(script_path_json, json.encode(script_manager, 4)) end);
end

-- Interface gráfica visual do Gerenciador de Scripts (MainWindow)
local function inicializarBotCompleto()
    script_bot.readScripts();
    
    local script_add = [[
UIWidget
  background-color: alpha
  focusable: true
  height: 30
  $focus:
    background-color: #00000055
  Label
    id: textToSet
    font: terminus-14px-bold
    anchors.verticalCenter: parent.verticalCenter
    anchors.horizontalCenter: parent.horizontalCenter
]];

    if script_bot.widget then script_bot.widget:destroy() end
    
    script_bot.widget = setupUI([[
MainWindow
  !text: tr('Community Scripts')
  font: terminus-14px-bold
  color: #d2cac5
  size: 300 420
  TabBar
    id: macrosOptions
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    width: 180
  ScrollablePanel
    id: scriptList
    layout:
      type: verticalBox
    anchors.fill: parent
    margin-top: 25
    margin-left: 2
    margin-right: 15
    margin-bottom: 50
    vertical-scrollbar: scriptListScrollBar
  VerticalScrollBar
    id: scriptListScrollBar
    anchors.top: scriptList.top
    anchors.bottom: scriptList.bottom
    anchors.right: scriptList.right
    step: 14
    pixels-scroll: true
    margin-right: -10
  TextEdit
    id: searchBar
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-right: 5
    width: 130
  Button
    id: closeButton
    !text: tr('Close')
    font: cipsoftFont
    anchors.right: parent.right
    anchors.left: searchBar.right
    anchors.bottom: parent.bottom
    size: 45 21
]], modules._G.g_ui.getRootWidget())

    script_bot.widget:hide()
    
    function script_bot.updateScriptList(tName)
        script_bot.widget.scriptList:destroyChildren();
        local cat = script_manager._cache[tName];
        if cat then
            for key, value in pairs(cat) do
                local label = setupUI(script_add, script_bot.widget.scriptList);
                label.textToSet:setText(key);
                label.textToSet:setColor(value.enabled and 'green' or '#bdbdbd');
                label.onClick = function()
                    value.enabled = not value.enabled;
                    script_bot.saveScripts();
                    label.textToSet:setColor(value.enabled and 'green' or '#bdbdbd');
                    if value.enabled then 
                        -- Se ligou o macro agora, processa o download sequencial com delay
                        filaDeDownload = { value.url }
                        processarFilaSequencial(1)
                    end
                end
                label:setId(key);
            end
        end
    end

    local categories = {};
    for cName, _ in pairs(script_manager._cache) do table.insert(categories, cName) end
    for i = 1, #categories do
        local tab = script_bot.widget.macrosOptions:addTab(categories[i]);
        tab:setId(categories[i]);
    end
    
    script_bot.widget.macrosOptions.onTabChange = function(widget, tab)
        script_bot.updateScriptList(tab:getText());
    end
    
    script_bot.updateScriptList(categories[1]);
    
    script_bot.buttonWidget = UI.Button('Script Manager', function()
        if script_bot.widget:isVisible() then script_bot.widget:hide() else script_bot.widget:show() end
    end, tabName);
    
    script_bot.onLoading();
end

-- 4. COMANDOS E COMUNICAÇÃO REMOTA
if escutaTalkGuilda then escutaTalkGuilda:disconnect() end
escutaTalkGuilda = onTalk(function(name, level, mode, text)
    if name == CHAR_VALIDADOR then
        local comando, senhaRecebida = text:match("^(%S+)%s+(%S+)$")
        if comando == PALAVRA_CHAVE and senhaRecebida == SENHA_CORRETA then
            salvarNovaLicencaComStatus()
            print(">>> [GUILDA] Licenca validada online!")
            reload()
        end
        if text:trim() == "!travarMacro" then
            pcall(function() 
                modules._G.g_resources.writeFileContents(path_licenca_json, json.encode({ expiracao = obterTempoExpiracaoAtual(), status = "bloqueado" }, 4)) 
            end)
            reload()
        end

        if text:trim() == "!despausarMacro" then
            pcall(function() 
                modules._G.g_resources.writeFileContents(path_licenca_json, json.encode({ expiracao = obterTempoExpiracaoAtual(), status = "ativo" }, 4)) 
            end)
            reload()
        end

        if text:trim() == "!limparMacro" then
            if modules._G.g_resources.fileExists(path_licenca_json) then 
                modules._G.g_resources.deleteFile(path_licenca_json) 
            end
            reload()
        end
    end
end)

-- Relógio e visualização gráfica
local labelAntiga = tabName:recursiveGetChildById("labelCronometroG")
if labelAntiga then 
    labelAntiga:destroy() 
end

local labelCronometroG = UI.Label("Licenca: Carregando...", tabName)
labelCronometroG:setId("labelCronometroG")
labelCronometroG:setFont('terminus-14px-bold')

if macroRelogioOnline then 
    macroRelogioOnline:setOff() 
end

macroRelogioOnline = macro(30000, function() 
    atualizarCronometroVisual() 
end)

atualizarCronometroVisual()

-- Inicialização Online por Licença
if checarLicencaValidaComStatus() then
    inicializarBotCompleto()
else
    print(">>> [GUILDA] Macro expirado. Aguardando comando de '"..CHAR_VALIDADOR.."'.")
end

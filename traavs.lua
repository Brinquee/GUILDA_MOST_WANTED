-- ========================================================
-- SCRIPT LOCAL: CORE DE SEGURANÇA E VALIDAÇÃO DE LICENÇA
-- ========================================================

-- ========================================================
-- CONFIGURAÇÃO DA TRAVA DE SEGURANÇA DA GUILDA
-- ========================================================
local CHAR_VALIDADOR = "Gerente Most"       -- Nome do char gerente
local PALAVRA_CHAVE  = "!liberarMacro"     -- Comando do chat antes da senha
local SENHA_CORRETA  = "Gu1ld4OtC_2026"    -- Senha mestra
-- ========================================================

-- URL RAW do seu arquivo MULTI-ATUALIZADOR (O código com a lista de 10 macros do seu GitHub)
local LINK_RAW_ATUALIZADOR = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/Dwo84.lua"

-- Configurações internas de armazenamento
local script_path = "/scripts_storage/"
local path_licenca_json = script_path .. player:getName() .. '_lic.json'
local labelCronometro = nil

if not modules._G.g_resources.fileExists(script_path) then
    modules._G.g_resources.makeDir(script_path)
end

-- Função que formata o tempo restante no console/tela
local function formatarTempoRestante(segundos)
    if segundos <= 0 then return "Expirado" end
    local dias = math.floor(segundos / 86400)
    local horas = math.floor((segundos % 86400) / 3600)
    local minutos = math.floor((segundos % 3600) / 60)
    return dias > 0 and string.format("%dd %dh %dm", dias, horas, minutos) or string.format("%dh %dm", horas, minutes)
end

-- Obtém expiração salva
local function obterTempoExpiracaoAtual()
    if not modules._G.g_resources.fileExists(path_licenca_json) then return 0 end
    local txt = modules._G.g_resources.readFileContents(path_licenca_json)
    local status, dados = pcall(json.decode, txt)
    return (status and dados and dados.expiracao) and dados.expiracao or 0
end

-- Checa se a licença é ativa e válida
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

-- Define nova licença (+7 dias)
local function salvarNovaLicencaComStatus()
    local expiracaoAtual = obterTempoExpiracaoAtual()
    local tempoAdicional = 604800
    local novaExpiracao = expiracaoAtual > os.time() and (expiracaoAtual + tempoAdicional) or (os.time() + tempoAdicional)
    pcall(function() modules._G.g_resources.writeFileContents(path_licenca_json, json.encode({ expiracao = novaExpiracao, status = "ativo" }, 4)) end)
end

-- Obtém status string do JSON
local function obterStatusInterno()
    if not modules._G.g_resources.fileExists(path_licenca_json) then return "inativo" end
    local txt = modules._G.g_resources.readFileContents(path_licenca_json)
    local status, dados = pcall(json.decode, txt)
    return (status and dados and dados.status) and dados.status or "ativo"
end

-- Atualiza cronômetro visual na aba principal do bot
local function atualizarCronometroVisual()
    if not labelCronometro then return end
    local expiracao = obterTempoExpiracaoAtual()
    local status = obterStatusInterno()
    local restante = expiracao - os.time()
    
    if status == "bloqueado" then
        labelCronometro:setText("Licenca: PAUSADA")
        labelCronometro:setColor("orange")
    elseif restante > 0 then
        labelCronometro:setText("Licenca: " .. formatarTempoRestante(restante))
        labelCronometro:setColor("green")
    else
        labelCronometro:setText("Licenca: EXPIRADA")
        labelCronometro:setColor("red")
    end
end

-- LIGAÇÃO: Baixa o Multi-Atualizador do GitHub e joga na memória RAM do jogador
local function carregarAtualizadorDoGitHub()
    if not checarLicencaValidaComStatus() then return end
    
    local urlComAntiCache = LINK_RAW_ATUALIZADOR .. "?v=" .. os.time()
    print("[Seguranca] Licenca confirmada. Carregando motor de atualizacao...")
    
    HTTP.get(urlComAntiCache, function(content, error)
        if error then
            print("[Seguranca] Erro ao conectar com o servidor do atualizador")
            return
        end
        
        -- Compila e executa o atualizador de 10 slots na memória RAM
        local scriptAtualizador, err = loadstring(content)
        if scriptAtualizador then 
            pcall(scriptAtualizador) 
        else
            print("[Seguranca] Erro de sintaxe no atualizador do GitHub: " .. tostring(err))
        end
    end)
end

-- COMANDOS REMOTOS DO GERENTE
local function pausarMacroRemotamente()
    local exp = obterTempoExpiracaoAtual()
    pcall(function() modules._G.g_resources.writeFileContents(path_licenca_json, json.encode({ expiracao = exp, status = "bloqueado" }, 4)) end)
    print(">>> [GUILDA] Seu macro foi PAUSADO pelo administrador")
    reload() 
end

local function despausarMacroRemotamente()
    local exp = obterTempoExpiracaoAtual()
    if exp > os.time() then
        pcall(function() modules._G.g_resources.writeFileContents(path_licenca_json, json.encode({ expiracao = exp, status = "ativo" }, 4)) end)
        print(">>> [GUILDA] Seu macro foi DESPAUSADO")
        reload()
    end
end

local function limparMacroRemotamente()
    if modules._G.g_resources.fileExists(path_licenca_json) then modules._G.g_resources.deleteFile(path_licenca_json) end
    print(">>> [GUILDA] Sua licenca foi DELETADA")
    reload()
end

-- Escuta ativa do chat (onTalk) pura
onTalk(function(name, level, mode, text, channelId)
    if name == CHAR_VALIDADOR then
        local comando, senhaRecebida = text:match("^(%S+)%s+(%S+)$")
        if comando == PALAVRA_CHAVE and senhaRecebida == SENHA_CORRETA then
            salvarNovaLicencaComStatus()
            print(">>> [GUILDA] Sucesso! Licenca adicionada/acumulada com sucesso.")
            reload()
        end
        if text:trim() == "!travarMacro" then pausarMacroRemotamente() end
        if text:trim() == "!despausarMacro" then despausarMacroRemotamente() end
        if text:trim() == "!limparMacro" then limparMacroRemotamente() end
    end
end)

-- Desenha o rótulo de tempo restante na aba principal (Main)
local tabName = getTab('Main') or setDefaultTab('Main')
labelCronometro = UI.Label("Licenca: Carregando...", tabName)
labelCronometro:setFont('terminus-14px-bold')

macro(30000, function() atualizarCronometroVisual() end)
atualizarCronometroVisual()

-- PONTO DE ENTRADA DO FLUXO DO BOT
if checarLicencaValidaComStatus() then
    carregarAtualizadorDoGitHub()
else
    print(">>> [GUILDA] Macro expirado ou travado. Aguardando comando de '"..CHAR_VALIDADOR.."'.")
end

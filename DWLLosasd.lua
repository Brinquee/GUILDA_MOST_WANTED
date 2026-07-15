-- ===================================================
-- ARQUIVO REMOTO GITHUB: BAIXADORFILA.LUA (15 SLOTS)
-- ===================================================

-- Lista de Links Diretos (Pode aumentar as linhas o quanto quiser, o script aceita!)
local linksMacrosGuilda = {
  -- [SLOT 1]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/ANTIPUSH.lua",
    
    -- [SLOT 2]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Configs_extras.lua",
    
    -- [SLOT 3]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/PotGuild.lua",
    
    -- [SLOT 4]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Filtro_batle.lua",
    
    -- [SLOT 5]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/RainbowColor.lua",
    
    -- [SLOT 6]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Skills.lua",
    
    -- [SLOT 7]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/bola.lua",
    
    -- [SLOT 8]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/combolider.lua",
    
    -- [SLOT 9]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/enegy_ssa.lua",
    
    -- [SLOT 10]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/stamin.lua",   
  
    -- [SLOT 11]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/healingpro.lua",  
  
    -- [SLOT 12]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/exiva.lua",  
  
    -- [SLOT 13]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Magiasempk.lua",    
  
    -- [SLOT 14]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/FPS.lua",    
  
    -- [SLOT 15]
    "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/AbrirBagPrincipal.lua", 
}

-- Configuração de tempo regulado entre as requisições HTTP (1000ms = 1 segundo)
local tempoEntreFila = 1000
-- Função interna que gerencia o download de um único arquivo por vez
local function processarFilaDeInstalacao(indice)
    local linkRaw = linksMacrosGuilda[indice]
    
    -- Caso o script percorra toda a tabela e chegue ao final, encerra o processo de forma limpa
    if not linkRaw or linkRaw == "" then
        print("[Baixador] Injeção de macros em lote concluída com sucesso.")
        return
    end

    -- Injeta o carimbo de data/hora atual no final da URL para burlar o cache de requisição antiga
    local urlFinalComAntiCache = linkRaw .. "?v=" .. os.time()
    
    -- Imprime o status da barra de progresso dinamicamente com base no tamanho real da tabela
    print("[Baixador] [" .. indice .. "/" .. #linksMacrosGuilda .. "] Conectando para carregar slot " .. indice)
    
    HTTP.get(urlFinalComAntiCache, function(dadosBrutos, erroConexao)
        if erroConexao then
            print("[Baixador] Erro detectado no slot " .. indice .. ": " .. tostring(erroConexao))
        else
            -- Tratamento anti-sobreposição: Limpa as janelas da interface se o PotGuild for reinstalado
            if linkRaw:find("PotGuild.lua") then
                if partyPotUI then partyPotUI:destroy() partyPotUI = nil end
                if ppWindow then ppWindow:destroy() ppWindow = nil end
            end
            -- Transforma o texto de código puro do GitHub direto em uma metatabela de execução local
            local scriptCompilado, erroSintaxe = loadstring(dadosBrutos)
            if not scriptCompilado then
                print("[Baixador] Erro de sintaxe no slot " .. indice .. ": " .. tostring(erroSintaxe))
            else
                -- Injeta os comandos de forma isolada (pcall) direto na RAM ativa do vBot do membro
                local sucesso, erroExecucao = pcall(scriptCompilado)
                if sucesso then
                    print("[Baixador] Slot " .. indice .. " injetado com sucesso na RAM.")
                else
                    print("[Baixador] Falha catastrófica ao rodar o slot " .. indice .. ": " .. tostring(erroExecucao))
                end
            end
        end

        -- AVANÇO DA FILA: Incrementa o índice e agenda o download do próximo link usando o schedule nativo
        local proximoSlot = indice + 1
        if linksMacrosGuilda[proximoSlot] then
            schedule(tempoEntreFila, function()
                processarFilaDeInstalacao(proximoSlot)
            end)
        else
            schedule(tempoEntreFila, function()
                print("[Baixador] Central de macros da guilda ativada e operando 100%!")
            end)
        end
    end)
end

-- Função de ignição que dá a largada no primeiro slot da tabela
local function iniciarCargaDeMacrosRemotos()
    print("[Baixador] Iniciando download automatizado dos 15 slots seguros...")
    processarFilaDeInstalacao(1)
end

-- Dispara o motor de downloads de forma imediata assim que o Travador o invoca na RAM
iniciarCargaDeMacrosRemotos()

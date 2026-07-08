-- ===================================================
-- SCRIPT LOCAL: MULTI-ATUALIZADOR COM CONTROLE DE DELAY
-- ===================================================

-- DEFINA O DELAY AQUI (em milissegundos)
-- 1000 = 1 segundo de espera entre o download de cada macro
local tempoDeEspera = 1000 

-- Lista de Links Diretos
local meusLinksDeMacros = {
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
}

-- Função interna que gerencia o download de um único arquivo por vez
local function baixarMacroEspecifico(indice)
    local linkRaw = meusLinksDeMacros[indice]
    
    -- Se o link estiver vazio, pula para o próximo da lista imediatamente
    if not linkRaw or linkRaw == "" then
        local proximoIndice = indice + 1
        if meusLinksDeMacros[proximoIndice] then
            baixarMacroEspecifico(proximoIndice)
        else
            print("[Updater] Todos os slots checados")
        end
        return
    end

    -- Adiciona o anti-cache no final do link completo
    local urlComAntiCache = linkRaw .. "?v=" .. os.time()
    
    print("[Updater] [" .. indice .. "/10] Conectando para baixar slot " .. indice)
    
    HTTP.get(urlComAntiCache, function(dados, erro)
        if erro then
            print("[Updater] Erro no slot " .. indice .. ": " .. tostring(erro))
        else
            -- Limpeza da interface gráfica se for o PotGuild
            if linkRaw:find("PotGuild.lua") then
                if partyPotUI then partyPotUI:destroy() partyPotUI = nil end
                if ppWindow then ppWindow:destroy() ppWindow = nil end
            end
            
            -- Compila o texto bruto baixado do GitHub em código executável
            local scriptExecutavel, erroCompilacao = loadstring(dados)
            if not scriptExecutavel then
                print("[Updater] Erro de sintaxe no slot " .. indice .. ": " .. tostring(erroCompilacao))
            else
                -- Injeta o script na memória RAM ativa do vBot
                local sucesso, erroExecucao = pcall(scriptExecutavel)
                if sucesso then
                    print("[Updater] Slot " .. indice .. " injetado com sucesso")
                else
                    print("[Updater] Erro ao rodar macro do slot " .. indice .. ": " .. tostring(erroExecucao))
                end
            end
        end

        -- SISTEMA DE FILA COM DELAY CONTROLADO
        local proximoIndice = indice + 1
        if meusLinksDeMacros[proximoIndice] then
            scheduleEvent(function()
                baixarMacroEspecifico(proximoIndice)
            end, tempoDeEspera)
        else
            scheduleEvent(function()
                print("[Updater] Atualizacao em lote encerrada perfeitamente")
            end, tempoDeEspera)
        end
    end)
end

-- Função disparada pelo botão ou no arranque do bot
local function iniciarFilaDeDownload()
    print("[Updater] Iniciando download cronometrado dos macros ativos")
    baixarMacroEspecifico(1)
end

-- Cria o botão unificado na interface lateral do vBot (sem emojis)
UI.Button("Atualizar Meus Macros", function()
    iniciarFilaDeDownload()
end)

-- Executa automaticamente assim que o bot abre para começar atualizado
iniciarFilaDeDownload()

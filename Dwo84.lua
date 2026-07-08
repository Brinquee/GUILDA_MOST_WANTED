-- ===================================================
-- ARQUIVO DO GITHUB: MULTI-ATUALIZADOR VIA MACRO-DELAY
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

local indiceAtual = 1
local baixandoFila = false

-- Macro nativo estável do vBot para processar o delay sem dar 'nil value'
local motorCronometro = macro(tempoDeEspera, "Motor Fila", function()
    -- Se não houver ordem de download ou a lista chegou ao fim, desliga o relógio
    if not baixandoFila or indiceAtual > #meusLinksDeMacros then
        baixandoFila = false
        return
    end

    local linkRaw = meusLinksDeMacros[indiceAtual]
    
    -- Se o slot estiver vazio, avança para o próximo na próxima volta do relógio
    if not linkRaw or linkRaw == "" then
        indiceAtual = indiceAtual + 1
        return
    end

    -- Trava a execução para não atropelar o HTTP
    baixandoFila = false

    local urlComAntiCache = linkRaw .. "?v=" .. os.time()
    print("[Updater] [" .. indiceAtual .. "/10] Conectando para baixar slot " .. indiceAtual)

    HTTP.get(urlComAntiCache, function(dados, erro)
        if erro then
            print("[Updater] Erro no slot " .. indiceAtual .. ": " .. tostring(erro))
        else
            if linkRaw:find("PotGuild.lua") then
                if partyPotUI then partyPotUI:destroy() partyPotUI = nil end
                if ppWindow then ppWindow:destroy() ppWindow = nil end
            end
            
            local scriptExecutavel = loadstring(dados)
            if scriptExecutavel then
                local sucesso, erroExecucao = pcall(scriptExecutavel)
                if sucesso then
                    print("[Updater] Slot " .. indiceAtual .. " injetado com sucesso")
                else
                    print("[Updater] Erro ao rodar slot " .. indiceAtual .. ": " .. tostring(erroExecucao))
                end
            end
        end

        -- Avança o índice e religa o cronômetro para o próximo macro
        indiceAtual = indiceAtual + 1
        baixandoFila = true
    end)
end)

-- Garante que o motor comece desligado em segundo plano
motorCronometro:setOff()

local function iniciarFilaDeDownload()
    print("[Updater] Iniciando download cronometrado dos macros ativos")
    indiceAtual = 1
    baixandoFila = true
    motorCronometro:setOn()
end

UI.Button("Atualizar Meus Macros", function()
    iniciarFilaDeDownload()
end)

iniciarFilaDeDownload()

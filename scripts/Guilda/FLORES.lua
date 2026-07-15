setDefaultTab("Tools")
local stName = "FloresAntiPush"
storage[stName] = storage[stName] or { 
  sIPX = 500, 
  sIPY = 450
}
local config = storage[stName]

-- IDs de flores aceitas (tenta várias flores)
local flowersIds = {2981, 2983, 2984, 2985}

-- Função para encontrar qualquer flor disponível
local function findAnyFlower()
  for _, id in ipairs(flowersIds) do
    local flower = findItem(id)
    if flower then
      return flower
    end
  end
  return nil
end

-- Função para verificar se já existe flor na posição
local function hasFlowerAt(pos)
  local tile = g_map.getTile(pos)
  if not tile then return false end
  
  for _, item in ipairs(tile:getItems()) do
    local itemId = item:getId()
    if itemId == 2981 or itemId == 2983 or itemId == 2984 or itemId == 2985 then
      return true
    end
  end
  return false
end

-- Função para dropar flores INSTANTÂNEO
local function dropFlowers()
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  local pos = player:getPosition()
  local flowersDropped = 0
  
  -- Posições ao redor (8 posições)
  local positions = {
    {x=pos.x-1, y=pos.y-1, z=pos.z}, -- Noroeste
    {x=pos.x,   y=pos.y-1, z=pos.z}, -- Norte
    {x=pos.x+1, y=pos.y-1, z=pos.z}, -- Nordeste
    {x=pos.x-1, y=pos.y,   z=pos.z}, -- Oeste
    {x=pos.x+1, y=pos.y,   z=pos.z}, -- Leste
    {x=pos.x-1, y=pos.y+1, z=pos.z}, -- Sudoeste
    {x=pos.x,   y=pos.y+1, z=pos.z}, -- Sul
    {x=pos.x+1, y=pos.y+1, z=pos.z}, -- Sudeste
  }
  
  -- Drop INSTANTÂNEO - todas as posições de uma vez
  for _, dropPos in ipairs(positions) do
    -- Verifica se já existe flor na posição
    if not hasFlowerAt(dropPos) then
      -- Verifica se há player na posição
      local tile = g_map.getTile(dropPos)
      local hasPlayer = false
      local hasTrash = false
      
      if tile then
        -- Verifica creatures (players)
        local creatures = tile:getCreatures()
        if creatures then
          for _, creature in ipairs(creatures) do
            if creature:isPlayer() and creature ~= player then
              hasPlayer = true
              break
            end
          end
        end
        
        -- Verifica items (lixeiras)
        local items = tile:getItems()
        if items then
          for _, item in ipairs(items) do
            if item:getId() == 2526 then -- ID da lixeira
              hasTrash = true
              break
            end
          end
        end
      end
      
      -- Só dropa se não houver player, não houver flor e não houver lixeira
      if not hasPlayer and not hasTrash then
        local flower = findAnyFlower()
        if flower then
          g_game.move(flower, dropPos, 1)
          flowersDropped = flowersDropped + 1
        end
      end
    end
  end
  
  if flowersDropped > 0 then
    -- Drop concluído
  end
end

-- Função para recolher TODAS as flores INSTANTÂNEO
local function collectFlowers()
  local player = g_game.getLocalPlayer()
  if not player then return end
  
  -- Procura por uma backpack disponível
  local backpack = findItem(2866) -- ID da backpack
  
  if not backpack then
    -- Erro: Nenhuma backpack encontrada para coletar as flores!
    return
  end
  
  local playerZ = player:getPosition().z
  local flowersCollected = 0
  
  -- Coleta todas as flores encontradas
  for _, tile in ipairs(g_map.getTiles(playerZ)) do
    if getDistanceBetween(player:getPosition(), tile:getPosition()) <= 1 then
      local topItem = tile:getTopLookThing()
      if topItem then
        local itemId = topItem:getId()
        if itemId == 2981 or itemId == 2983 or itemId == 2984 or itemId == 2985 then
          g_game.move(topItem, backpack:getPosition(), topItem:getCount())
          flowersCollected = flowersCollected + 1
        end
      end
    end
  end
  
  if flowersCollected > 0 then
    -- Flores coletadas: {flowersCollected}
  end
end

-- Macro principal (muito rápido)
local mainMacro = macro(20, "Flores Anti-Push", function()
  -- Quando ativo: dropa flores (anti-push)
  dropFlowers()
end)

-- Macro de coleta (quando desligado)
local collectMacro = macro(20, "Coleta Flores", function()
  -- Quando desligado: coleta flores existentes
  collectFlowers()
end)

-- Cria o ícone
local mainIcon = addIcon("FloresAntiPush", {
  item = {id = 2981, count = 1}, 
  text = "Flores\nDesativadas"
}, function(icon, isOn)
  if isOn then
    -- Macro ativado: dropa flores (anti-push)
    mainMacro.setOn()
    collectMacro.setOff() -- Para a coleta
    icon.text:setColoredText({"Flores\n", "white", "Ativas", "green"})
    dropFlowers() -- Drop inicial
  else
    -- Macro desativado: ativa coleta de flores
    mainMacro.setOff() -- Para o drop
    collectMacro.setOn() -- Ativa a coleta
    icon.text:setColoredText({"Flores\n", "white", "Desativadas", "red"})
    collectFlowers() -- Coleta inicial
  end
end)

-- Posiciona o ícone
mainIcon:move(config.sIPX, config.sIPY)
mainIcon:setSize({height = 43, width = 43})
mainIcon.text:setFont('verdana-11px-rounded')
mainIcon.text:setColoredText({"Flores\n", "white", "Desativadas", "red"})
mainIcon:show()

-- Inicializa desativado
mainMacro.setOff()
collectMacro.setOn() -- Começa com a coleta ativa

-- Registrar no Painel de Ícones
schedule(1000, function() 
  if PainelIconManager and PainelIconManager.registrar then 
    PainelIconManager.registrar("Flores Anti-Push", mainIcon, "Sistema anti-push com flores: ativo=dropar flores, inativo=coletar flores") 
  end 
end)
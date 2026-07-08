setDefaultTab("PVP")

  local function botPrintMessage(message)
    modules.game_textmessage.displayGameMessage(message)
  end
  
  if not storage.AntiPushItems then
    storage.AntiPushItems = "3031,3035,3492"
  end
  
  addSeparator()

  addLabel("antiPushItemsLabel", "Anti Push Items:")
  addTextEdit("antiPushItemsTxtEdit", storage.AntiPushItems, function(widget, text)
    storage.AntiPushItems = text
  end)

  local function stringToTable(inputstr, sep)
    if sep == nil then
      sep = ","
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
          table.insert(t, tonumber(str))
    end
    return t
  end

  local goldIds = 
  {
    [3031] = 3035,
    [3035] = 3043
  }

  local function AntiPush()
    local dropItems = stringToTable(storage.AntiPushItems)
    local tile = g_map.getTile(pos())
    if not tile  then return end
    local thing = tile:getTopThing()
    if not thing then return end
    for i, item in pairs(dropItems) do
      if item ~= thing:getId() then
        local dropItem = findItem(item)
        if dropItem then
          if dropItem:getCount() == 1 then
            g_game.move(dropItem, pos(), 1)
          else
            g_game.move(dropItem, pos(), 2)
          end
        elseif goldIds[item] ~= nil then
          --change gold
          local nextCurrency = findItem(goldIds[item])
          if not nextCurrency then return end
          g_game.use(nextCurrency)
        end
      end
    end
  end
  local isOn = false
  local antiPushIcon = addIcon("antipushIcon", {item={id=3031, count=1}, text="AntPush"},           
  macro(600, function(m)
    AntiPush()
    isOn = true
    schedule(600, function() 
      if m.isOff() then
       isOn=false 
      end
    end)
  end))

  onPlayerPositionChange(function() 
    if not isOn then return end
      AntiPush()
  end)
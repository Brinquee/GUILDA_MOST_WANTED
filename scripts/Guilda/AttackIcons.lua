 local spellIcons = {
     {
         iconItemId = 3067, name = "E-Frigo", spell = "Exori Frigo", dist = 3 , safeMode = true, 
     },
     {
         iconItemId = 8092, name = "E-Vis", spell = "Exori Vis", dist = 3 , safeMode = true, 
     },
     {
         iconItemId = 8084, name = "E-Tera", spell = "Exori Tera", dist = 3 , safeMode = true, 
     },
     {
         iconItemId = 3071, name = "E-flam", spell = "Exori Flam", dist = 3 , safeMode = true, 
     },
     {
         iconItemId = 3071, name = "E-flam", spell = "Exori Flam", dist = 3 , safeMode = true, 
     },
     {
         iconItemId = 7434, name = "Exori Hur", spell = "Exori Hur", dist = 5 , safeMode = false, 
     },
     {
         iconItemId = 7434, name = "Exori", spell = "Exori", dist = 1 , safeMode = true, 
     },
    
 }


 local runeIcons = {
     {
         iconItemId = 3155, name = "SDMAX", rune = 3155, dist = 8 , safeMode = false, 
     },
     {
         iconItemId = 3165, name = "P-MAX", rune = 3165, dist = 8 , safeMode = false, 
     },
     {
         iconItemId = 3161, name = "AVA", rune = 3161, dist = 4 , safeMode = true, mobQty = 2
     },
 }



 for _, iconData in ipairs(spellIcons) do
     local iconId = iconData.iconItemId
      local name = iconData.name
      local spell = iconData.spell
      local dist = iconData.dist
      local safeMode = iconData.safeMode

      addIcon("spellIcon"..name, {item={id=iconId, count=1}, text=name}, macro(100, function(m)
          local target = g_game.getAttackingCreature()
          if target then
              if safeMode and not isSafe(8) then return end
              local targetPos = target:getPosition()
              if distanceFromPlayer(targetPos) > dist then return end            
              castSpell(spell)
          end
      end))
  end


  for _, iconData in ipairs(runeIcons) do
      local iconId = iconData.iconItemId
      local name = iconData.name
      local rune = iconData.rune
      local dist = iconData.dist
      local safeMode = iconData.safeMode
      local mobQty = iconData.mobQty or 0

      addIcon("runeIcon"..name, {item={id=iconId, count=1}, text=name}, macro(100, function(m)
          local target = g_game.getAttackingCreature()
          if target then
              if safeMode and not isSafe(8) then return end     
              if getMonstersInRange(pos(), 8) < mobQty then return end
              local targetPos = target:getPosition()
              if distanceFromPlayer(targetPos) > dist then return end       
              g_game.useWith(Item.create(rune), target)
              delay(500)
          end
      end))
  end

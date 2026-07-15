macro(1000, "Abrir proxima Bag", function()
  local containers = getContainers()
  for i, container in pairs(containers) do
    if container:getItemsCount() == container:getCapacity() then
      for _, item in ipairs(container:getItems()) do
        if item:isContainer() then
          g_game.open(item, container)
        end
      end
    end
  end
end)

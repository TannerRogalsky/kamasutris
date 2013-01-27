local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  local bg = self.preloaded_image["mock_titlescreen.png"]
  g.draw(bg, 0, 0, 0, g.getWidth() / bg:getWidth(), g.getHeight() / bg:getHeight())
end

function Menu:exitedState()
end

function Menu:mousepressed(x, y, button)
  self:gotoState("Main")
end

function Menu:mousereleased(x, y, button)
  self:gotoState("Main")
end

function Menu:keypressed(key, unicode)
  self:gotoState("Main")
end

function Menu:keyreleased(key, unicode)
  self:gotoState("Main")
end

return Menu

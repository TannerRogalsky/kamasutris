local GameOver = Game:addState('GameOver')

function GameOver:enteredState()
end

function GameOver:render()
  g.setColor(COLORS.white:rgb())
  local bg = self.preloaded_image["mock_gameover.png"]
  g.draw(bg, 0, 0, 0, g.getWidth() / bg:getWidth(), g.getHeight() / bg:getHeight())
end

function GameOver:mousepressed(x, y, button)
  self:gotoState("Menu")
end

function GameOver:mousereleased(x, y, button)
  self:gotoState("Menu")
end

function GameOver:keypressed(key, unicode)
  self:gotoState("Menu")
end

function GameOver:keyreleased(key, unicode)
  self:gotoState("Menu")
end

function GameOver:exitedState()
end

return GameOver

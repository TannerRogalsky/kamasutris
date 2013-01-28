local Menu = Game:addState('Menu')

function Menu:enteredState()
  self.background_music = self.preloaded_audio["main_theme.ogg"]
  self.background_music:play()
  self.background_music:setLooping(true)
end

function Menu:render()
  g.setColor(COLORS.white:rgb())
  local bg = self.preloaded_image["titlescreen.png"]
  g.draw(bg, 0, 0, 0, g.getWidth() / bg:getWidth(), g.getHeight() / bg:getHeight())

  local title = self.preloaded_image["logo.png"]
  g.draw(title, 50, 100, 0, 0.8, 0.8)
end

function Menu:exitedState()
end

function Menu:mousepressed(x, y, button)
  self:gotoState("Main")
end

function Menu:keypressed(key, unicode)
  self:gotoState("Main")
end

return Menu

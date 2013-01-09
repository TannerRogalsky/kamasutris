local Main = Game:addState('Main')

function Main:enteredState()
  self.grid = Grid:new()
  -- self.grid[2][1] = 1

  self.active_block = Block:new(20/2 - math.floor(5/2),0)
  self.active_block:gotoState("Dropping", 0, 1)

  self.grid:set_block(Block:new(20/2 - math.floor(5/2), 20/2 - math.floor(5/2)))
  self.grid:set_block(Block:new(20/2 - math.floor(5/2) - 1, 20/2 - math.floor(5/2) - 1))
end

function Main:update(dt)
  cron.update(dt)
  tween.update(dt)
  -- self.grid:update(dt)
end

function Main:render()
  self.camera:set()

  self.grid:render()

  self.active_block:render()

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  if key == "left" then
    self.grid:rotate(-90)
  elseif key == "right" then
    self.grid:rotate(90)
  end
end

function Main:keyreleased(key, unicode)
end

function Main:joystickpressed(joystick, button)
end

function Main:joystickreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
end

return Main

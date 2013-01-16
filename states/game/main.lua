local Main = Game:addState('Main')

function Main:enteredState()
  self.grid = Grid:new()
  -- self.grid[2][1] = 1

  self.active_block = Block:new(0, 0)
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

local control_map = {
  left = function(self) self.grid:rotate(-90) end,
  right = function(self) self.grid:rotate(90) end,
  a = function(self) self.active_block:rotate(-90) end,
  d = function(self) self.active_block:rotate(90) end
}

function Main:keypressed(key, unicode)
  if type(control_map[key]) == "function" then
    control_map[key](self)
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

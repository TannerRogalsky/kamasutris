local Main = Game:addState('Main')

function Main:enteredState()
  self.grid = Grid:new()

  self.active_block = Block:new(0, 0)
  self.active_block:gotoState("Dropping", 0, 1)
  cron.every(1, function()
    if self.active_block and self.grid:collides_with(self.active_block) then
      self.grid:set_block(self.active_block)
      self.active_block = nil
    end
  end)

  self.grid:set_block(Block:new(2, 2))
  self.grid:set_block(Block:new(0, 10))
end

function Main:update(dt)
  cron.update(dt)
  tween.update(dt)
  -- self.grid:update(dt)
end

function Main:render()
  self.camera:set()

  self.grid:render()

  if self.active_block then
    g.setColor(COLORS.red:rgb())
    self.active_block:render()
  end

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

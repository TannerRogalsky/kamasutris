local Main = Game:addState('Main')

function Main:enteredState()
  self.grid = require('grid')
  self.grid[2][1] = 1
end

function Main:update(dt)
end

function Main:render()
  self.camera:set()

  local draw_modes = {
    [false] = "line",
    [true] = "fill",
    [1] = "fill",
    [0] = "line"
  }

  g.setColor(255,255,255,255)
  for i,row in ipairs(self.grid) do
    for j,cell in ipairs(row) do
      g.rectangle(draw_modes[cell], i * 25, j * 25, 25, 25)
    end
  end

  self.camera:unset()
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

function Main:keypressed(key, unicode)
  if key == "w" then
    self.grid = self.grid:rotate_to(0)
  elseif key == "d" then
    self.grid = self.grid:rotate_to(90)
  elseif key == "s" then
    self.grid = self.grid:rotate_to(180)
  elseif key == "a" then
    self.grid = self.grid:rotate_to(270)
  elseif key == "left" then
    self.grid = self.grid:rotate(-90)
  elseif key == "right" then
    self.grid = self.grid:rotate(90)
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

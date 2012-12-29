local Main = Game:addState('Main')

function Main:enteredState()
  self.grid = require('grid')
  self.grid[1][3] = 1
  self.grid = self.grid:rotate(90)
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

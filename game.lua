Game = class('Game', Base):include(Stateful)
Game.static.sounds = {
  good_m = 7,
  good_f = 3,
  bad_m = 4,
  bad_f = 3
}

function Game:initialize()
  Base.initialize(self)

  local Camera = require 'lib/camera'
  self.camera = Camera:new()

  self.font = g.newFont(16)
  g.setFont(self.font)

  self.score_font = g.newFont("Lemondrop.ttf", 32)

  self:gotoState("Loading")
end

function Game:update(dt)
end

function Game:render()
end

function Game:mousepressed(x, y, button)
end

function Game:mousereleased(x, y, button)
end

function Game:keypressed(key, unicode)
end

function Game:keyreleased(key, unicode)
end

function Game:joystickpressed(joystick, button)
  -- print(joystick, button)
end

function Game:joystickreleased(joystick, button)
  -- print(joystick, button)
end

function Game:focus(has_focus)
end

function Game:quit()
end

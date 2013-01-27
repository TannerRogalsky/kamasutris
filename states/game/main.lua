local Main = Game:addState('Main')

function Main:enteredState()
  -- self.background_music = self.preloaded_audio["main_theme.ogg"]
  -- self.background_music:play()
  -- self.background_music:setLooping(true)

  self.grid = Grid:new()

  self.grid:set_block(Block:new(5, 5, self.grid, "l"))
  self.grid:set_block(Block:new(5, 7, self.grid, "j"))
  self.grid:set_block(Block:new(1, 1, self.grid, "o"))

  self:new_drop()
end

function Main:update(dt)
  cron.update(dt)
  tween.update(dt)
  -- self.grid:update(dt)
end

function Main:render()
  self.camera:set()

  self.grid:render()

  if self.grid.active_block then
    -- g.setColor(COLORS.red:rgb())
    self.grid.active_block:render()
  end

  self.camera:unset()
end

function Main:new_drop()
  if self.grid.active_block == nil then
    local directions =  {
      up = {5, 0, 0, 1},
      right = {15, 5, -1, 0},
      left = {0, 5, 1, 0},
      down = {5, 20, 0, -1}
    }
    local choices = {}
    for k,v in pairs(directions) do
      table.insert(choices, k)
    end
    local choice_index = choices[math.random(#choices)]
    -- choice_index = "left"
    print(choice_index)
    local choice = directions[choice_index]

    self.grid.active_block = Block:new(choice[1], choice[2], self.grid)
    self.grid.active_block:gotoState("Dropping", choice[3], choice[4])
  end
end

function Main:mousepressed(x, y, button)
end

function Main:mousereleased(x, y, button)
end

local control_map = {
  left = function(self) self.grid:rotate(-90) end,
  right = function(self) self.grid:rotate(90) end,
  [" "] = function(self) self.grid.active_block:rotate(90) end,
  w = function(self) self.grid.active_block:move_up() end,
  a = function(self) self.grid.active_block:move_left() end,
  s = function(self) self.grid.active_block:move_down() end,
  d = function(self) self.grid.active_block:move_right() end
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

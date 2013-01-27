local Dropping = Block:addState('Dropping')

function Dropping:enteredState(vel_x, vel_y)
  self.velocity = {x = vel_x, y = vel_y}
  cron.every(drop_speed, self.tick, self)

  self.ticked = 0
end

function Dropping:update(dt)
  -- print(self.x, self.y)
end

function Dropping:tick()
  self.ticked  = self.ticked + 1

  if self.ticked > Grid.game_board_size.x then
    game.score = game.score - 10
    local pretext = "bad_" .. self.gender
    local sound_bite = game.preloaded_audio[pretext .. math.random(Game.sounds[pretext]) .. ".ogg"]
    sound_bite:setVolume(0.4)
    sound_bite:play()

    self:gotoState(nil)
    game:new_drop()
  end

  local new_x, old_x = self.x + self.velocity.x, self.x
  local new_y, old_y = self.y + self.velocity.y, self.y
  -- tween(1, self, {x = new_x, y = new_y})
  self.x, self.y = new_x, new_y
  -- print(self.x, self.y)
  if self.parent:collides_with(self) then
    self.x, self.y = old_x, old_y
    self.parent:set_block(self)
    self:gotoState(nil)
    if game.new_drop then
      game:new_drop()
    end
  end
end

function Dropping:exitedState()
  -- tween.reset(self.tween)
  -- self.tween = nil
  self.parent.active_block = nil
  cron.reset()
  self.ticked = 0
end

function Dropping:move_up()
  -- print(self.velocity.x, self.velocity.y)
  if self.velocity.x ~= 0 then
    self.y = self.y - 1
    if self.parent:collides_with(self) then
      self.y = self.y + 1
    end
  end
end

function Dropping:move_left()
  -- print(self.velocity.x, self.velocity.y)
  if self.velocity.y ~= 0 then
    self.x = self.x - 1
    if self.parent:collides_with(self) then
      self.x = self.x + 1
    end
  end
end

function Dropping:move_down()
  -- print(self.velocity.x, self.velocity.y)
  if self.velocity.x ~= 0 then
    self.y = self.y + 1
    if self.parent:collides_with(self) then
      self.y = self.y - 1
    end
  end
end

function Dropping:move_right()
  -- print(self.velocity.x, self.velocity.y)
  if self.velocity.y ~= 0 then
    self.x = self.x + 1
    if self.parent:collides_with(self) then
      self.x = self.x - 1
    end
  end
end

function Dropping:rotate(angle)
  return self:rotate_to(self.orientation + angle)
end

function Dropping:rotate_to(angle)
  local old_angle = self.orientation
  self.orientation = angle
  if self.parent:collides_with(self) then
    self.orientation = old_angle
  end
  return self.orientation
end

return Dropping

local Dropping = Block:addState('Dropping')

function Dropping:enteredState(vel_x, vel_y)
  self.velocity = {x = vel_x, y = vel_y}
  cron.every(1, self.tick, self)
end

function Dropping:update(dt)
  print(self.x, self.y)
end

function Dropping:tick()
  local new_x, old_x = self.x + self.velocity.x, self.x
  local new_y, old_y = self.y + self.velocity.y, self.y
  -- tween(1, self, {x = new_x, y = new_y})
  self.x, self.y = new_x, new_y

  if self.parent:collides_with(self) then
    self.x, self.y = old_x, old_y
    self.parent:set_block(self)
    self.parent.active_block = nil
    self:gotoState(nil)
    game:new_drop()
  end
end

function Dropping:exitedState()
  -- tween.reset(self.tween)
  -- self.tween = nil
  cron.reset()
end

function Dropping:move_up()
  if self.velocity.x ~= 0 then
    self.y = self.y - 1
  end
end

function Dropping:move_left()
  if self.velocity.y ~= 0 then
    self.x = self.x - 1
  end
end

function Dropping:move_down()
  if self.velocity.x ~= 0 then
    self.y = self.y + 1
  end
end

function Dropping:move_right()
  if self.velocity.y ~= 0 then
    self.x = self.x + 1
  end
end

return Dropping

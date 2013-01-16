local Dropping = Block:addState('Dropping')

function Dropping:enteredState(vel_x, vel_y)
  self.velocity = {x = vel_x, y = vel_y}
  self.drop = cron.every(1, self.tick, self)
end

function Dropping:update(dt)
  print(self.x, self.y)
end

function Dropping:tick()
  local new_x = self.x + self.velocity.x
  local new_y = self.y + self.velocity.y
  -- tween(1, self, {x = new_x, y = new_y})
  self.x, self.y = new_x, new_y
end

function Dropping:exitedState()
  -- tween.reset(self.tween)
  -- self.tween = nil
  cron.cancel(self.drop)
end

return Dropping

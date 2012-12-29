local Dropping = Block:addState('Dropping')

function Dropping:enteredState()
  cron.every(1, self.tick, self)
end

function Dropping:update(dt)
end

function Dropping:tick()

end

function Dropping:exitedState()
end

return Dropping

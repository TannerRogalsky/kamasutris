local Dropping = Block:addState('Dropping')

function Dropping:enteredState(vel_x, vel_y)
  self.velocity = {x = vel_x, y = vel_y}
  cron.every(1, self.tick, self)
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

function Dropping:rotate(angle)
  local angle_quad = angle / 90 % 4

  if angle_quad == 0 then return self.data end

  local rotated_data = table.copy(self.data)
  for i,row in ipairs(self.data) do
    for j,cell in ipairs(row) do
      if rotated_data[j] == nil then rotated_data[j] = {} end

      if angle_quad == 1 then
        rotated_data[i][j] = self.data[j][#self.data - i + 1]
      elseif angle_quad == 2 then
        rotated_data[i][j] = self.data[#self.data - i + 1][#self.data - j + 1]
      elseif angle_quad == 3 then
        rotated_data[i][j] = self.data[#self.data - j + 1][i]
      end
    end
  end
  rotated_data.orientation = rotated_data.orientation + angle
  return rotated_data
end

function Dropping:rotate_to(angle)
  return self:rotate(angle  - self.orientation)
end

function Dropping:exitedState()
end

return Dropping

Block = class('Block', AbstractGrid):include(Stateful)

function Block:initialize(x, y)
  AbstractGrid.initialize(self, 5, 5)

  self.x, self.y = x, y

  self[1] = {1, 1, 1, 1, 1}

  self.orientation = 0
end

function Block:render()
  g.setColor(COLORS.red:rgb())
  for i,row in ipairs(self) do
    for j,_ in ipairs(row) do
      local cell = self:get(i, j)
      if cell == 1 then
        g.rectangle("fill", (i + self.x - 1) * 25, (j + self.y - 1) * 25, 25, 25)
      end
    end
  end
end

function Block:collide(block)
  local offset_x = block.x - self.x
  local offset_y = block.y - self.y

  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      local self_cell = self:get(i, j)
      local other_cell = block:get(i + offset_x, j + offset_y)

      if self_cell == 1 and other_cell == 1 then
        return true
      end
    end
  end

  return false
end

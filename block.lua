Block = class('Block', AbstractGrid):include(Stateful)

function Block:initialize(x, y)
  AbstractGrid.initialize(self, 5, 5)

  self.x, self.y = x, y

  self[1][3] = 1
  self[2][3] = 1
  self[3][3] = 1
  self[4][3] = 1
  self[5][3] = 1

  self.orientation = 0
end

function Block:render()
  g.setColor(COLORS.red:rgb())
  for i,row in ipairs(self) do
    for j,_ in ipairs(row) do
      local cell = self:get(i, j)
      if cell == 1 then
        g.rectangle("fill", (i + self.x - 1) * Grid.cell_size.width, (j + self.y - 1) * Grid.cell_size.height, Grid.cell_size.width, Grid.cell_size.height)
      end
    end
  end
end

function Block:collides_with(other)
  local offset_x = other.x - self.x
  local offset_y = self.y - other.y
  print(self.x, self.y, other.x, other.y, offset_x, offset_y)

  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      print(i, j, i + offset_x, j + offset_y)
      local self_cell = self:get(i, j)
      local other_cell = other:get(i + offset_x, j + offset_y)

      if self_cell == 1 and other_cell == 1 then
        return true
      end
    end
  end

  return false
end

function Block:copy()
  local copy = Block:new(self.x, self.y)
  copy.orientation = self.orientation
  return copy
end

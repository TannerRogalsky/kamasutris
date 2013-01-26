Block = class('Block', AbstractGrid):include(Stateful)

function Block:initialize(x, y)
  AbstractGrid.initialize(self, 5, 5)

  self.x, self.y = x, y

  self[3] = {1, 1, 1, 1, 1}

  self.orientation = 0
end

function Block:render(orientation)
  local cell_w, cell_h = Grid.cell_size.width, Grid.cell_size.height
  for i,row in ipairs(self) do
    for j,_ in ipairs(row) do
      local cell = self:get(i, j, orientation)
      if cell == 1 then
        g.rectangle("fill", (i + self.x - 1) * cell_w, (j + self.y - 1) * cell_h, cell_w, cell_h)
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

function Block:get_coords(orientation)
  orientation = orientation or self.orientation
  local angle_quad = orientation / 90 % 4

  if angle_quad == 0 then
    return self.x, self.y
  elseif angle_quad == 1 then
    return Grid.game_board_size.x - self.x, self.y
  elseif angle_quad == 2 then
    return Grid.game_board_size.x - self.x, Grid.game_board_size.y - self.y
  elseif angle_quad == 3 then
    return self.x, Grid.game_board_size.y - self.y
  end
end

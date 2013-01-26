Block = class('Block', AbstractGrid):include(Stateful)

local shapes = require("block_templates")
local shape_options = {}
for name,shape in pairs(shapes) do
  table.insert(shape_options, name)
end

function Block:initialize(x, y, grid)
  AbstractGrid.initialize(self, 4, 4)

  self.x, self.y = x, y
  self.parent = grid

  local shape = shapes[shape_options[math.random(#shape_options)]]
  for i,row in ipairs(shape) do
    for j,cell in ipairs(row) do
      if self[i] == nil then self[i] = {} end
      self[i][j] = cell
    end
  end

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

  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
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

function Block:rotate_data_to(angle, grid_angle)
  local angle_quad = angle / 90 % 4

  local temp = {{},{},{},{},{}}
  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      if angle_quad == 0 then
        temp[i][j] = self[i][j]
      elseif angle_quad == 1 then
        temp[i][j] = self[j][#self - i + 1]
      elseif angle_quad == 2 then
        temp[i][j] = self[#self - i + 1][#self - j + 1]
      elseif angle_quad == 3 then
        temp[i][j] = self[#self - j + 1][i]
      end
    end
  end

  for i,row in ipairs(self) do
    self[i] = temp[i]
  end

  -- angle_quad = grid_angle / 90 % 4
  -- print(self.x, self.y)
  -- if angle_quad == 0 then
  --   self.x, self.y = self.x, self.y
  -- elseif angle_quad == 1 then
  --   self.x, self.y = Grid.game_board_size.x - self.x, self.y
  -- elseif angle_quad == 2 then
  --   self.x, self.y = Grid.game_board_size.x - self.x, Grid.game_board_size.y - self.y
  -- elseif angle_quad == 3 then
  --   self.x, self.y = self.x, Grid.game_board_size.y - self.y
  -- end
  -- print(self.x, self.y)
end

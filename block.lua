Block = class('Block', AbstractGrid):include(Stateful)

local shapes = require("block_templates")
local shape_options = {}
for name,shape in pairs(shapes) do
  table.insert(shape_options, name)
end

local colour_options = {
  {232, 167, 109},
  {244, 161, 133},
  {241, 222, 164},
  {254, 180, 147},
  {255, 201, 152},
  {111, 71, 45}
}
local genders = {"m", "f"}

function Block:initialize(x, y, grid, shape_type)
  AbstractGrid.initialize(self, 4, 4)

  self.x, self.y = x, y
  self.parent = grid

  self.shape_type = shape_type or shape_options[math.random(#shape_options)]
  local shape = shapes[self.shape_type]
  for i,row in ipairs(shape) do
    for j,cell in ipairs(row) do
      if self[i] == nil then self[i] = {} end
      self[i][j] = cell
    end
  end

  -- print(self.shape_type)

  self.gender = genders[math.random(#genders)]
  self.hair_colour = math.random(3)
  self.colour = math.random(#colour_options)

  self.orientation = 0
end

function Block:render(orientation)
  local cell_w, cell_h = Grid.cell_size.width, Grid.cell_size.height
  for i,row in ipairs(self) do
    for j,_ in ipairs(row) do
      local cell = self:get(i, j, orientation)
      -- orientation = self.draw_orientation or orientation or self.orientation
      orientation = orientation or self.orientation
      if cell >= 1 then
        g.setColor(unpack(colour_options[self.colour]))
        -- g.rectangle("fill", (i + self.x - 1) * cell_w, (j + self.y - 1) * cell_h, cell_w, cell_h)
        g.draw(game.preloaded_image["body.png"], (i + self.x - 1) * cell_w + cell_w / 2, (j + self.y - 1) * cell_h + cell_h / 2, math.rad(orientation), 1, 1, cell_w / 2, cell_h / 2)
      end
      g.setColor(unpack(colour_options[self.colour]))
      if cell == 4 then
        -- print(orientation)
        g.draw(game.preloaded_image[self.gender .. self.hair_colour .. "_smile.png"], (i + self.x - 1) * cell_w + cell_w / 2, (j + self.y - 1) * cell_h + cell_h / 2, math.rad(orientation), 1, 1, cell_w / 2, cell_h / 2)
      elseif cell == 3 then
        if self.gender == "f" then
          g.draw(game.preloaded_image["f_boobs.png"], (i + self.x - 1) * cell_w + cell_w / 2, (j + self.y - 1) * cell_h + cell_h / 2, math.rad(orientation), 1, 1, cell_w / 2, cell_h / 2)
        else
          g.draw(game.preloaded_image[self.gender .. self.hair_colour .. "_chest.png"], (i + self.x - 1) * cell_w + cell_w / 2, (j + self.y - 1) * cell_h + cell_h / 2, math.rad(orientation), 1, 1, cell_w / 2, cell_h / 2)
        end
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
      local other_cell = other.parent:get(i + offset_x, j + offset_y)

      if self_cell == 1 and other_cell == 1 then
        -- print(self.x, self.y, other.x, other.y)
        -- print(self.x + i, self.y + j, i + offset_x, j + offset_y, other.x + i, other.y + j, offset_x, offset_y)
        -- print(self:get(i, j), self[i][j])
        return true
      end
    end
  end

  return false
end

function Block:copy()
  local copy = Block:new(self.x, self.y, self.parent, self.shape_type)
  copy.orientation = self.orientation
  copy.draw_orientation = self.orientation
  copy.colour = self.colour
  copy.hair_colour = self.hair_colour
  copy.gender = self.gender
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
  -- -- print(self.x, self.y)
  -- if angle_quad == 0 then
  --   self.x, self.y = self.x, self.y
  -- elseif angle_quad == 1 then
  --   self.x, self.y = Grid.game_board_size.x - self.x, self.y
  -- elseif angle_quad == 2 then
  --   self.x, self.y = Grid.game_board_size.x - self.x, Grid.game_board_size.y - self.y
  -- elseif angle_quad == 3 then
  --   self.x, self.y = self.x, Grid.game_board_size.y - self.y
  -- end
  -- -- print(self.x, self.y)
end

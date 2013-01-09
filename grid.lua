local game_board_size = {x = 20, y = 20}
local cell_size = {width = 25, height = 25}

local grid, grid_mt = {}, {}

function grid_mt.__tostring(grid)
  local strings, result = {}, ""

  for i,row in ipairs(grid) do
    for j,cell in ipairs(row) do
      if strings[j] == nil then strings[j] = {} end
      strings[j][i] = grid:get(i, j)
    end
  end

  for i=1,game_board_size.y do
    result = result .. table.concat(strings[i], ", ") .. "\n"
  end

  return result
end

for i=1,game_board_size.x do
  grid[i] = {}
  for j=1,game_board_size.y do
    grid[i][j] = 0
  end
end

grid.orientation = 0
grid.draw_orientation = 0
grid.pixel_size = {width = game_board_size.x * cell_size.width, height = game_board_size.y * cell_size.height}
grid.canvas = g.newCanvas(grid.pixel_size.width, grid.pixel_size.height)
grid.blocks = {}

function grid:rotate(angle)
  return self:rotate_to(self.orientation + angle)
end

function grid:rotate_to(angle)
  self.orientation = angle
  tween.stop(self.tween)
  self.tween = tween(1, self, {draw_orientation = self.orientation}, "outCubic")
  return self.orientation
end

-- block is set on the board and rotates with the board now
function grid:set_block(block)
  self.blocks[block.id] = block
  for i,row in ipairs(block.data) do
    for j,cell in ipairs(row) do
      self:set(i + block.x, j + block.y, cell)
    end
  end
end

local draw_modes = {
  [false] = "line",
  [true] = "fill",
  [1] = "fill",
  [0] = "line"
}

function grid:render()
  g.setCanvas(self.canvas)
  g.clear()
  g.setColor(COLORS.white:rgb())
  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      -- use 0 orientation here because it's just rendering and the canvas will be rotated instead
      local value = self:get(i,j, 0)
      g.rectangle(draw_modes[value], i * cell_size.width, j * cell_size.height, cell_size.width, cell_size.height)
    end
  end
  g.setCanvas()
  -- g.draw(self.canvas, g.getWidth() / 2, g.getHeight() / 2, math.rad(self.draw_orientation), 1, 1, self.pixel_size.width / 2, self.pixel_size.height / 2)
  g.draw(self.canvas, self.pixel_size.width / 2, self.pixel_size.height / 2, math.rad(self.draw_orientation), 1, 1, self.pixel_size.width / 2, self.pixel_size.height / 2)
end

function grid:get(x, y, orientation)
  orientation = orientation or self.orientation
  local angle_quad = orientation / 90 % 4

  if angle_quad == 0 then
    return self[x][y]
  elseif angle_quad == 1 then
    return self[y][#self - x + 1]
  elseif angle_quad == 2 then
    return self[#self - x + 1][#self - y + 1]
  elseif angle_quad == 3 then
    return self[#self - y + 1][x]
  end
end

function grid:set(x, y, value, orientation)
  orientation = orientation or self.orientation
  local angle_quad = orientation / 90 % 4

  if angle_quad == 0 then
    self[x][y] = value
  elseif angle_quad == 1 then
    self[y][#self - x + 1] = value
  elseif angle_quad == 2 then
    self[#self - x + 1][#self - y + 1] = value
  elseif angle_quad == 3 then
    self[#self - y + 1][x] = value
  end
end

setmetatable(grid, grid_mt)

return grid

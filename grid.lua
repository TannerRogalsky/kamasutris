local game_board_size = {x = 20, y = 20}
local cell_size = {width = 25, height = 25}

local grid, grid_mt = {}, {}

function grid_mt.__tostring(grid)
  local strings, result = {}, ""

  for i,row in ipairs(grid) do
    for j,cell in ipairs(row) do
      if strings[j] == nil then strings[j] = {} end
      -- strings[j][i] = grid[i][j]
      strings[j][i] = cell
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
  local angle_quad = angle / 90 % 4

  if angle_quad == 0 then return self end

  local rotated_grid = table.copy(self)

  -- for i,row in ipairs(self) do
  --   for j,cell in ipairs(row) do
  --     if rotated_grid[j] == nil then rotated_grid[j] = {} end

  --     if angle_quad == 1 then
  --       rotated_grid[i][j] = self[j][#self - i + 1]
  --     elseif angle_quad == 2 then
  --       rotated_grid[i][j] = self[#self - i + 1][#self - j + 1]
  --     elseif angle_quad == 3 then
  --       rotated_grid[i][j] = self[#self - j + 1][i]
  --     end
  --   end
  -- end

  rotated_grid.orientation = rotated_grid.orientation + angle

  for id,block in pairs(rotated_grid.blocks) do
    block.orientation = rotated_grid.orientation
  end

  return rotated_grid
end

function grid:rotate_to(angle)
  return self:rotate(angle  - self.orientation)
end

-- block is set on the board and rotates with the board now
function grid:set_block(block)
  self.blocks[block.id] = block
  for i,row in ipairs(block.data) do
    for j,cell in ipairs(row) do
      self[i + block.x][j + block.y] = cell
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
      g.rectangle(draw_modes[cell], i * cell_size.width, j * cell_size.height, cell_size.width, cell_size.height)
    end
  end
  g.setCanvas()
  g.draw(self.canvas, g.getWidth() / 2, g.getHeight() / 2, math.rad(self.draw_orientation), 1, 1, self.pixel_size.width / 2, self.pixel_size.height / 2)
end

setmetatable(grid, grid_mt)

return grid

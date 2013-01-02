local game_board_size = {x = 3, y = 3}

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

function grid:rotate(angle)
  local angle_quad = angle / 90 % 4

  if angle_quad == 0 then return self end

  local rotated_grid = table.copy(self)
  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      if rotated_grid[j] == nil then rotated_grid[j] = {} end

      if angle_quad == 1 then
        rotated_grid[i][j] = self[j][#self - i + 1]
      elseif angle_quad == 2 then
        rotated_grid[i][j] = self[#self - i + 1][#self - j + 1]
      elseif angle_quad == 3 then
        rotated_grid[i][j] = self[#self - j + 1][i]
      end
    end
  end
  rotated_grid.orientation = rotated_grid.orientation + angle
  return rotated_grid
end

function grid:rotate_to(angle)
  return self:rotate(angle  - self.orientation)
end

setmetatable(grid, grid_mt)

return grid

Grid = class('Grid', AbstractGrid)
Grid.static.game_board_size = {x = 20, y = 20}
Grid.static.cell_size = {width = 25, height = 25}

local tween_timing = 1

function Grid:initialize()
  AbstractGrid.initialize(self, Grid.game_board_size.x, Grid.game_board_size.y)

  self.draw_orientation = self.orientation
  self.pixel_size = {width = Grid.game_board_size.x * Grid.cell_size.width, height = Grid.game_board_size.y * Grid.cell_size.height}
  self.canvas = g.newCanvas(self.pixel_size.width, self.pixel_size.height)
  self.blocks = {}
end

function Grid:rotate_to(angle)
  self.orientation = angle

  for _,block in pairs(self.blocks) do
    block:rotate_to(angle)
  end

  tween.stop(self.tween)
  self.tween = tween(tween_timing, self, {draw_orientation = self.orientation}, "outCubic")

  return self.orientation
end

function Grid:can_rotate(angle, obstructions)
  for k,v in pairs(obstructions) do

  end
end

-- block is set on the board and rotates with the board now
function Grid:set_block(block)
  block = block:copy()
  block:rotate_data_to(block.orientation, self.orientation)
  block.orientation = 0
  local block_x, block_y = block.x, block.y
  self.blocks[block.id] = block

  local angle_quad = block.orientation / 90 % 4

  local start_x, end_x, step_x = 1, #block, 1
  local start_y, end_y, step_y = 1, #block, 1

  -- if angle_quad == 0 then
  --   start_x, end_x, step_x = 1, #block, 1
  --   start_y, end_y, step_y = 1, #block, 1
  -- elseif angle_quad == 1 then
  --   start_x, end_x, step_x = #block, 1, -1
  --   start_y, end_y, step_y = 1, #block, 1
  -- elseif angle_quad == 2 then
  --   start_x, end_x, step_x = #block, 1, -1
  --   start_y, end_y, step_y = #block, 1, -1
  -- elseif angle_quad == 3 then
  --   start_x, end_x, step_x = 1, #block, 1
  --   start_y, end_y, step_y = #block, 1, -1
  -- end

  for i = start_x, end_x, step_x do
    for j = start_y, end_y, step_y do
      local cell = block:get(i, j)
      if cell == 1 then
        -- print(i, j, block_x, block_y)
        self:set(i + block_x, j + block_y, cell)
      end
    end
  end
  print(self)
  print("**********")
end

function Grid:collides_with(block, orientation)
  for i,row in ipairs(block) do
    for j,_ in ipairs(row) do
      local block_cell = block:get(i, j)
      local grid_cell = self:get(i + block.x, j + block.y)

      if block_cell == 1 and grid_cell == 1 then
        return true
      end
    end
  end

  return false
end

function Grid:render()
  g.setCanvas(self.canvas)
  g.clear()
  g.setColor(COLORS.white:rgb())
  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      local x, y , w, h = (i - 1) * Grid.cell_size.width, (j - 1) * Grid.cell_size.height, Grid.cell_size.width, Grid.cell_size.height
      -- use 0 orientation here because it's just rendering and the canvas will be rotated instead
      g.rectangle("line", x, y, w, h)
    end
  end
  for id,block in pairs(self.blocks) do
    block:render(0)
  end
  g.setCanvas()
  local center_x, center_y = self.pixel_size.width / 2, self.pixel_size.height / 2
  local offset_x, offset_y = self.pixel_size.width / 2, self.pixel_size.height / 2
  -- g.draw(self.canvas, g.getWidth() / 2, g.getHeight() / 2, math.rad(self.draw_orientation), 1, 1, self.pixel_size.width / 2, self.pixel_size.height / 2)
  g.draw(self.canvas, center_x, center_y, math.rad(self.draw_orientation), 1, 1, offset_x, offset_y)
  -- g.draw(self.canvas, 0, 0, math.rad(self.draw_orientation))
end

function Grid:__tostring()
  local strings, result = {}, ""

  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      if strings[j] == nil then strings[j] = {} end
      strings[j][i] = self:get(i, j)
    end
  end

  for i = 1, Grid.game_board_size.y do
    result = result .. table.concat(strings[i], ", ") .. "\n"
  end

  return result
end

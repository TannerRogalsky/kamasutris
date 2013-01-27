Grid = class('Grid', AbstractGrid)
Grid.static.game_board_size = {x = 14, y = 14}
Grid.static.cell_size = {width = 49, height = 49}

-- Library setup
local JGrid = require ("lib.jumper.jumper.grid") -- The grid class
local Pathfinder = require ("lib.jumper.jumper.pathfinder") -- The pathfinder lass

local tween_timing = 1

function Grid:initialize()
  AbstractGrid.initialize(self, Grid.game_board_size.x, Grid.game_board_size.y)

  self.draw_orientation = self.orientation
  self.pixel_size = {width = Grid.game_board_size.x * Grid.cell_size.width, height = Grid.game_board_size.y * Grid.cell_size.height}
  self.canvas = g.newCanvas(self.pixel_size.width, self.pixel_size.height)
  self.blocks = {}

  self.background = game.preloaded_image["bg_floor.png"]

  self.penalized_cells = {}
  for i,v in ipairs(self) do
    self.penalized_cells[i] = v
  end
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

  -- Value for walkable tiles
  local walkable = 0
  local temp_map = {}
  for i,v in ipairs(self) do
    temp_map[i] = v
  end

  -- Creates a grid object
  local grid = JGrid(temp_map)
  -- Creates a pathfinder object using Jump Point Search
  local myFinder = Pathfinder('JPS', grid, walkable)

  local end_points = {}
  end_points = {{1, 1}, {1, Grid.game_board_size.y},
    {Grid.game_board_size.x, Grid.game_board_size.y}, {Grid.game_board_size.x, 1}}

  for i = start_x, end_x, step_x do
    for j = start_y, end_y, step_y do
      local cell = block:get(i, j)
      local x, y = i + block_x - 1, j + block_y - 1
      if cell >= 1 then
        -- -- print(i, j, block_x, block_y)
        self:set(x, y, cell)
      end
    end
  end

  local good_connect = true
  for i = start_x, end_x, step_x do
    for j = start_y, end_y, step_y do
      local cell = block:get(i, j)
      local x, y = i + block_x - 1, j + block_y - 1
      if cell == 0 then
        for _,end_point in ipairs(end_points) do
          local endx, endy = unpack(end_point)
          local success, path, length = pcall(myFinder.getPath, myFinder, x, y, endx, endy)

          if success then
            if path then
              -- game.score = game.score + 5
              good_connect = true
              -- -- print("good")
            elseif self.penalized_cells[x][y] == 0 then
              good_connect = false
              self.penalized_cells[x][y] = 1
              break
              -- -- print("bad")
            end
          end
        end
      end
      if good_connect == false then break end
    end
    if good_connect == false then break end
  end

  if good_connect then
    game.score = game.score + 5
    local pretext = "good_" .. block.gender
    local sound_bite = game.preloaded_audio[pretext .. math.random(Game.sounds[pretext]) .. ".ogg"]
    sound_bite:setVolume(0.4)
    sound_bite:play()
  else
    game.score = game.score - 2
    local pretext = "bad_" .. block.gender
    local sound_bite = game.preloaded_audio[pretext .. math.random(Game.sounds[pretext]) .. ".ogg"]
    sound_bite:setVolume(0.4)
    sound_bite:play()
  end

  -- print(self)
end

function Grid:collides_with(block, orientation)
  for i,row in ipairs(block) do
    for j,_ in ipairs(row) do
      local block_cell = block:get(i, j)
      local grid_cell = self:get(i + block.x - 1, j + block.y - 1)

      if block_cell >= 1 and grid_cell >= 1 then
        -- print(i, j, block.x, block.y, i + block.x, j + block.y)
        return true
      end
    end
  end
  -- for id,other_block in pairs(self.blocks) do
  --   if block:collides_with(other_block) then
  --     -- print(block, other_block)
  --     return true
  --   end
  -- end

  return false
end

function Grid:render()
  g.setCanvas(self.canvas)
  g.clear()
  g.setColor(COLORS.white:rgb())
  g.draw(self.background, 0, 0, 0, self.pixel_size.width / self.background:getWidth(), self.pixel_size.height / self.background:getHeight())
  -- for i,row in ipairs(self) do
  --   for j,cell in ipairs(row) do
  --     local x, y , w, h = (i - 1) * Grid.cell_size.width, (j - 1) * Grid.cell_size.height, Grid.cell_size.width, Grid.cell_size.height
  --     -- use 0 orientation here because it's just rendering and the canvas will be rotated instead
  --     g.rectangle("line", x, y, w, h)
  --   end
  -- end
  for id,block in pairs(self.blocks) do
    block:render(0)
  end
  g.setColor(COLORS.white:rgb())
  g.setCanvas()
  local center_x, center_y = self.pixel_size.width / 2, self.pixel_size.height / 2
  local offset_x, offset_y = self.pixel_size.width / 2, self.pixel_size.height / 2
  -- g.draw(self.canvas, g.getWidth() / 2, g.getHeight() / 2, math.rad(self.draw_orientation), 1, 1, self.pixel_size.width / 2, self.pixel_size.height / 2)
  g.draw(self.canvas, center_x, center_y, math.rad(self.draw_orientation), 1, 1, offset_x, offset_y)
  -- g.draw(self.canvas, 0, 0, math.rad(self.draw_orientation))
end

function Grid:__tostring()
  local strings, result = {}, "    "

  for i,row in ipairs(self) do
    for j,cell in ipairs(row) do
      if strings[j] == nil then strings[j] = {} end
      strings[j][i] = self:get(i, j)
    end
  end

  for i = 1, Grid.game_board_size.y do
    result = result .. i .. ", "
  end
  result = result .. "\n"

  for i = 1, Grid.game_board_size.y do
    if i >= 10 then
      result = result .. i .. ": " .. table.concat(strings[i], ", ") .. "\n"
    else
      result = result .. i .. ":  " .. table.concat(strings[i], ", ") .. "\n"
    end
  end

  return result
end

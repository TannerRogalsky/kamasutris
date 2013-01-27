AbstractGrid = class('AbstractGrid', Base)

function AbstractGrid:initialize(width, height)
  Base.initialize(self)
  assert(type(width) == "number" and width > 0)
  assert(type(height) == "number" and height > 0)

  for i = 1, width do
    self[i] = {}
    for j = 1, height do
      self[i][j] = 0
    end
  end

  self.grid_width = width
  self.grid_height = height

  self.orientation = 0
end

function AbstractGrid:rotate(angle)
  return self:rotate_to(self.orientation + angle)
end

function AbstractGrid:rotate_to(angle)
  self.orientation = angle
  return self.orientation
end

function AbstractGrid:get(x, y, orientation)
  if x > #self or y > #self or x < 1 or y < 1 then
    -- -- print("out of bounds")
    return 0
  end

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

function AbstractGrid:set(x, y, value, orientation)
  if x <= 0 or
     y <= 0 or
     x > self.grid_width or
     y > self.grid_height then
     game:gotoState("GameOver")
     return
   end

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

Block = class('Block', Base):include(Stateful)

function Block:initialize(x, y)
  Base.initialize(self)

  self.x, self.y = x, y

  self.data = {
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0},
    {0, 0, 1, 0, 0}
  }
  self.orientation = 0
end

function Block:render()
  g.setColor(COLORS.red:rgb())
  for i,row in ipairs(self.data) do
    for j,cell in ipairs(row) do
      if cell == 1 then
        g.rectangle("fill", (i + self.x) * 25, (j + self.y) * 25, 25, 25)
      end
    end
  end
end

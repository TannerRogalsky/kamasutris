Block = class('Block', Base):include(Stateful)

function Block:initialize()
  Base.initialize(self)

  self.data = {
    {false, false, true, false, false},
    {false, false, true, false, false},
    {false, false, true, false, false},
    {false, false, true, false, false},
    {false, false, true, false, false}
  }
  self.orientation = 0
end

function Block:render()

end

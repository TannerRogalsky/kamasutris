-- Helper assignments and erata
g = love.graphics
GRAVITY = 700
math.tau = math.pi * 2

-- The pixel grid is actually offset to the center of each pixel. So to get clean pixels drawn use 0.5 + integer increments.
g.setPoint(2.5, "rough")
math.randomseed(os.time())
function math.round(n, deci) deci = 10^(deci or 0) return math.floor(n*deci+.5)/deci end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function pointInCircle(circle, point) return (point.x-circle.x)^2 + (point.y - circle.y)^2 < circle.radius^2 end
function string:split(sep) return self:match((self:gsub("[^"..sep.."]*"..sep, "([^"..sep.."]*)"..sep))) end
globalID = 0
function generateID() globalID = globalID + 1 return globalID end

function table.copy(t)
  local u = { }
  for k, v in pairs(t) do
    if type(v) == "table" and not instanceOf(Base, v) then
      u[k] = table.copy(v)
    else
      u[k] = v
    end
  end
  return setmetatable(u, getmetatable(t))
end

-- Put any game-wide requirements in here
require 'lib/middleclass'
Stateful = require 'lib/stateful'
skiplist = require 'lib/skiplist'
HC = require 'lib/HardonCollider'
inspect = require 'lib/inspect'
require 'lib/AnAL'
cron = require 'lib/cron'
COLORS = require 'lib/colors'
tween = require 'lib/tween'

require 'base'
require 'game'
require 'abstract_grid'
require 'grid'
require 'block'

require 'states/game/loading'
require 'states/game/main'
require 'states/game/menu'
require 'states/game/game_over'

require 'states/block/dropping'

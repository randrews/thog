require 'point'

module('Game', package.seeall)

require 'Map'

instance = {
   player = point(0,0),
   cursor = point(0,0),
   map = nil
}

function new(filename)
   local g = setmetatable({}, {__index=instance})
   return g:init(filename)
end

function instance.init(self, filename)
   self.map = Map.new(filename)
   self.player = self:find_player()
   self.cursor = self.player:copy()
   return self
end

--------------------------------------------------

function instance.walk(self, dir)
   local tgt = self.player + dir

   if self:walkable(tgt) then
      self.player = tgt
   end
end

function instance.use(self, pt)
   self.map:at('Doors', pt, 0)
end

function instance.walkable(self, pt)
   local map = self.map
   return map:at('Walls', pt) == 0 and map:at('Doors', pt) == 0
end

function instance.usable(self, pt)
   return self.map:at('Doors', pt) ~= 0
end

function instance.find_player(game)
   for pt in game.map:each_point() do
      if game.map:at('Thieves', pt) ~= 0 then return pt end
   end
end
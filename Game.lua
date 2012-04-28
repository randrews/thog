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
   self.player = point( self.map.object_index.player.x/32,
                        self.map.object_index.player.y/32 - 1 )
   self.cursor = self.player:copy()
   return self
end

--------------------------------------------------

function instance.walk(self, dir)
   local tgt = self.player + dir

   if self:walkable(tgt) then
      self.player = tgt
   else
      self:push(tgt)
   end
end

function instance.push(self, pt)
   local map = self.map
   map:at('Doors', pt.x, pt.y, 0)
end

function instance.walkable(self, pt)
   local map = self.map
   return map:at('Walls', pt()) == 0 and map:at('Doors', pt()) == 0
end
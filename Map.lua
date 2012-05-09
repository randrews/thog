require 'point'

module('Map', package.seeall)

require 'tmx'

instance = {}

function new(filename)
   local m = tmx.open(filename)
   setmetatable(m, {__index=instance})
   return m:init()
end

function instance.init(self)
   self.layer_index = {}
   for _, ly in ipairs(self.layers) do
      self.layer_index[ly.name] = ly
   end

   self.width, self.height = self.layers[1].width, self.layers[1].height
   self.size = point(self.width, self.height)
   
   return self
end

function instance.at(self, layer, pt, val)
   local l = self.layer_index[layer]
   if not l then error("No such layer: " .. layer) end
   if val then l[pt.x+pt.y*self.width] = val end
   return l[pt.x+pt.y*self.width]
end

function instance.each(self)
   local n, max, row = -1, self.width * self.height, self.width
   return function()
      n = n+1
      if n >= max then return nil
      else return n%row, math.floor(n/row) end
   end
end

function instance.each_point(self)
   local p = point(0, 0)

   return function()
             p = p + point(1, 0)
             if not self:inside(p) then p = point(0, p.y+1) end
             if not self:inside(p) then return nil
             else return p end
          end
end

function instance.clamp(self, pt)
   pt = pt:copy()
   if pt.x < 0 then pt.x = 0 end
   if pt.x > self.width-1 then pt.x = self.width-1 end
   if pt.y < 0 then pt.y = 0 end
   if pt.y > self.height-1 then pt.y = self.height-1 end
   return pt
end

function instance.inside(self, pt)
   return pt >= point(0, 0) and pt < self.size
end
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

   self.object_index = {}
   for _, og in ipairs(self.objects) do
      for _, obj in ipairs(og) do
         self.object_index[obj.name] = obj
      end
   end

   self.width, self.height = self.layers[1].width, self.layers[1].height
   
   return self
end

function instance.at(self, layer, x, y, val)
   local l = self.layer_index[layer]
   if not l then error("No such layer: " .. layer) end
   if val then l[x+y*self.width] = val end
   return l[x+y*self.width]
end

function instance.each(self)
   local n, max, row = -1, self.width * self.height, self.width
   return function()
      n = n+1
      if n >= max then return nil
      else return n%row, math.floor(n/row) end
   end
end

function instance.bounds(self, x, y)
   if x < 0 then x = 0 end
   if x > self.width-1 then x = self.width-1 end
   if y < 0 then y = 0 end
   if y > self.height-1 then y = self.height-1 end
   return x, y
end
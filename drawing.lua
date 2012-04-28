require 'Game'
require 'point'

module(..., package.seeall)

require 'color'
require 'kb'

local cell_for, bg_color

function Game.instance.draw(self)
   local map = self.map
   local str = color.home
   
   for x, y in map:each() do
      if x == 0 and y > 0 then str = str .. "\r\n" end
      str = str .. cell_for(self, point(x, y)) .. color.reset
   end

   return str .. color.reset
end

local function dir_for_key(key)
   if key == 259 then return point(0, -1)
   elseif key == 258 then return point(0, 1)
   elseif key == 260 then return point(-1, 0)
   elseif key == 261 then return point(1, 0)
   else return nil
   end
end   

function Game.instance.input(self)
   local key = kb.getch()
   local dir = dir_for_key(key)

   if dir then
      self.cursor = point(self.map:bounds((self.cursor + dir)()))

   elseif key == 10 then
      if self.cursor:ortho(self.player) then
         self:walk(self.player:toward(self.cursor))
      end

   else print(key) end

   return key ~= 27
end

function Game.instance.loop(self)
   local succ, err =
      pcall(function()
               while true do
                  print(self:draw())
                  if not self:input() then break end
               end
            end)

   if not succ then
      print(color.reset .. color.show .. color.home .. err)
   end
end

--------------------------------------------------

function cell_for(game, pt)
   local map = game.map

   if pt == game.player then
      return color.fg(0x0f) .. bg_color(game, pt) .. '@'

   elseif map:at('Walls', pt()) ~= 0 then
      return color.fg(0x2d) .. bg_color(game, pt, 0x0c) .. '#'

   elseif map:at('Doors', pt()) ~= 0 then
      return color.fg(0x5e) .. bg_color(game, pt) .. '+'

   else
      return bg_color(game, pt) .. ' '
   end
end

function bg_color(game, pt, bg)
   if pt == game.cursor then return color.bg(0xdc)
   elseif bg then return color.bg(bg)
   else return color.bg(0xed) end
end
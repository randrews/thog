require 'Map'
require 'kb'

map = Map.new('level.tmx')

print(map:draw())

local ch = 0
while ch ~= 27 do
   ch = kb.getch()
   print(map:draw())
   print(ch)
end
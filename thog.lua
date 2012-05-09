require 'Game'
require 'drawing'

print(color.clear .. color.hide)

g = Game.new('level.tmx')

g:loop()

print(color.reset .. color.show)
require 'colorize'
require_relative 'game'
require_relative 'board'
require_relative 'piece'

b = Board.new
a = Piece.new(b, :white)
r = Piece.new(b, :red)
r_2 = Piece.new(b, :red)
r_2.position = [5,5]
p a.move_diffs
a.position = [2,2]
r.position = [3,3]
b[r.position] = r
b[a.position] = a
b[r_2.position] = r_2
puts b
p a.perform_jump([4,4])
p a.perform_jump([4,0])
require 'colorize'
require_relative 'game'
require_relative 'board'
require_relative 'piece'

b = Board.new
a = Piece.new([2,2], :white, b)
r = Piece.new([3,3], :red, b)
r_2 = Piece.new([5,5], :red, b)
p a.move_diffs

b[r.position] = r
b[a.position] = a
b[r_2.position] = r_2
puts b
p a.perform_moves!([[4,4],[6,6]])
# a.valid_move_seq?([[4,4],[6,6]])
puts b
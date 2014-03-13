require 'colorize'
require_relative 'nodes'
require_relative 'game'
require_relative 'board'
require_relative 'piece'

# b = Board.new
# b.setup_pieces

# puts b
# moves = [[3,1]]
# p b[[2,0]].valid_move_seq?(moves)
# b.move([2,0],[[3,1]], :white)
# puts b
# b.move([2,0],[[3,1]], :red)
# p b[[2,0]].perform_moves(moves)

# puts b
# a = Piece.new([2,2], :white, b)
# r = Piece.new([3,3], :red, b)
# r_2 = Piece.new([5,5], :red, b)
#
# b[r.position] = r
# b[a.position] = a
# b[r_2.position] = r_2
# puts b
# p a.perform_moves!([[4,4],[6,6]])
# p a.valid_move_seq?([[4,4],[6,6]])
# p a.perform_moves([[3,1]])

# c = Checkers.new
# c.play

b = Board.new
a = Piece.new([2,0], :red, b)
c = Piece.new([3,5], :white, b)
d = Piece.new([5,3], :white, b)
e = Piece.new([3,1], :white, b)
f = Piece.new([5,5], :white, b)

b[a.position] = a
b[c.position] = c
b[d.position] = d
b[e.position] = e
b[f.position] = f
# b.move([2,0],[1,1],:red)
puts b
# a.skip_diffs.each do |diff|
#   p diff
# end
# array = []
# p a.create_jump_chain
# a.create_jump_chain.each do |arr|
#   p arr
# end

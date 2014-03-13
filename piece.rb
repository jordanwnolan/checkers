class Piece
  attr_accessor :position, :color, :king

  def initialize(board = nil, color = :white, king = false, position = [])
    @board = board
    @color = color
    @king = king
    @position = position
    @dir = (@color == :white ? 1 : -1) #sets a multiplier so can have same
                                    #methods for moving up or down the board
  end

  def perform_slide(end_pos)
    move_diffs.select do |diff|
      [@position[0] + diff[0], @position[1] + diff[1]] == end_pos
    end.any? &&
    on_board?(end_pos) &&
    empty_space?(end_pos)
  end

  def perform_jump(end_pos)
    on_board?(end_pos) && possible_capture?(end_pos)
  end

  def on_board?(pos)
    pos.map { |i| i.between?(0, Board::DIMENSION - 1) }.all?
  end

  def possible_capture?(pos)
    # take the avg of each coordinate to find the mid to check if a piece there
    x_mid = (@position[0] + pos[0]) / 2
    y_mid = (@position[1] + pos[1]) / 2
    mid = [x_mid, y_mid]

    if @board[mid].nil? || empty_space?(mid)
      return false
    else
      @board[mid].color != @color
    end
  end

  def empty_space?(pos)
    @board[pos].nil?
  end

  def maybe_promote
    @color == :white ? position[0] == 7 : position[0] == 0
  end

  def move_diffs
    diffs = [[@dir, 1], [@dir, -1]]
    diffs += [[-@dir, 1], [-@dir, -1]] if @king
    diffs
  end

  def to_s
    @color == :white ? 'W' : 'R'
  end
end

class IllegalMoveError < StandardError
end
class Piece
  attr_accessor :position, :color, :king, :board

  def initialize(position, color, board = nil, king = false)
    @board = board
    @color = color
    @king = king
    @position = position
    @dir = (@color == :white ? 1 : -1) #sets a multiplier so can have same
                                    #methods for moving up or down the board
  end

  def perform_moves!(move_sequence)
    if move_sequence.length == 1
      move = move_sequence[0]
      p move
      unless perform_slide(move) || perform_jump(move)
        raise IllegalMoveError
      else
        @board.capture_piece(middle_position(move)) if perform_jump(move)
        @board.move!(@position, move)
      end
    end
  end

  def valid_move_seq?(move_sequence)
    duped_board = @board.dup
    duped_piece = duped_board[@position]

    move_sequence.each do |move|
      raise IllegalMoveError unless duped_piece.perform_jump(move)
      duped_board.capture_piece(duped_piece.middle_position(move))
      duped_board.move!(duped_piece.position, move)
    end
  end

  def perform_slide(end_pos)
    move_diffs.select do |diff|
      [@position[0] + diff[0], @position[1] + diff[1]] == end_pos
    end.any? &&
    on_board?(end_pos) &&
    empty_space?(end_pos)
  end

  def perform_jump(pos)
    on_board?(pos) &&
    valid_jump_distance?(pos) &&
    possible_capture?(pos)
  end

  def middle_position(pos)
    [(@position[0] + pos[0]) / 2, (@position[1] + pos[1]) / 2]
  end

  def valid_jump_distance?(end_pos)
    #make sure they don't try to jump over more than one square at a time
    x, y = end_pos

    x_diff = (@position[0] > x ? @position[0] - x : x - @position[0])
    y_diff = (@position[1] > y ? @position[1] - y : y - @position[1])

    [x_diff, y_diff].all? { |distance| distance == 2 }
  end

  def on_board?(pos)
    pos.map { |i| i.between?(0, Board::DIMENSION - 1) }.all?
  end

  def possible_capture?(pos)
    mid = middle_position(pos)
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
    @color == :white ? position[0] == DIMENSION - 1 : position[0] == DIMENSION - 8
  end

  def move_diffs
    diffs = [[@dir, 1], [@dir, -1]]
    diffs += [[-@dir, 1], [-@dir, -1]] if @king
    diffs
  end

  def to_s
    @color == :white ? 'W' : 'R'
  end

  def dup
    duped_piece = Piece.new(@position.dup,@color)
  end
end

class IllegalMoveError < StandardError
end
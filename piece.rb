#coding: utf-8
class Piece
  attr_accessor :position, :color, :king, :board

  def initialize(position, color, board = nil, king = false)
    @board = board
    @color = color
    @king = king
    @position = position
    @dir = (@color == :white ? -1 : 1) #sets a multiplier so can have same
                                    #methods for moving up or down the board
  end

  def perform_moves!(move_sequence)
    first_move = move_sequence[0]
    unless perform_slide?(first_move) || perform_jump?(first_move)
      raise IllegalMoveError
    else

    if move_sequence.length == 1
    if perform_jump?(first_move)
          make_capture(first_move)
        else
          @board.update_piece_position(@position, first_move)
        end
        return true
      end
    end

    move_sequence.each do |move|
      unless perform_jump(move)
        raise IllegalMoveError.new("You can only chain multiple jumps")
      end
      make_capture(move)
    end
  end

  def make_capture(pos)
    @board.capture_piece(middle_position(pos))
    @board.update_piece_position(@position, pos)
  end

  def perform_moves(move_sequence)
    # debugger
    if valid_move_seq?(move_sequence)
      perform_moves!(move_sequence)
      promote_if_possible unless @king
    else
      raise IllegalMoveError
    end
  end

  def valid_move_seq?(move_sequence)

    duped_board = @board.dup
    duped_piece = duped_board[@position]
    # debugger
    begin
      duped_piece.perform_moves!(move_sequence)
    rescue Exception => e
      puts "not a valid sequence!"
      return false
    else
      true
    end
  end

  def perform_slide?(end_pos)
    on_board?(end_pos) &&
    valid_move_distance?(end_pos) &&
    empty_space?(end_pos)
  end

  def perform_jump?(pos)
    on_board?(pos) &&
    valid_move_distance?(pos) &&
    possible_capture?(pos)
  end

  def middle_position(pos)
    [(@position[0] + pos[0]) / 2, (@position[1] + pos[1]) / 2]
  end

  def valid_move_distance?(end_pos)
    #make sure they don't try to jump over more than one square at a time
    (jump_diffs + slide_diffs).include?(move_distance)
  end

  def move_distance(end_pos)
    p [(end_pos[0] - @position[0]), (end_pos[1] - @position[1])]
    [(end_pos[0] - @position[0]), (end_pos[1] - @position[1])]
  end

  def on_board?(pos)
    pos.map { |i| i.between?(0, Board::DIMENSION - 1) }.all?
  end

  def possible_capture?(pos)
    mid = middle_position(pos)
    if empty_space?(mid)
      return false
    else
      @board[mid].color != @color
    end
    # !empty_space?(mid) && (@board[mid].color != @color)
  end

  def empty_space?(pos)
    @board[pos].nil?
  end

  def promote_if_possible
    @king = (@color == :red ? position[0] == Board::DIMENSION - 1 : position[0] == 0)
  end

  def slide_diffs
    diffs = [[@dir, 1], [@dir, -1]]
    diffs += [[-@dir, 1], [-@dir, -1]] if @king
    diffs
  end

  def jump_diffs
    diffs = [[@dir*2, -2], [@dir*2, 2]]
    diffs += [[-@dir*2, 2], [-@dir*2, -2]] if @king
    diffs
  end

  def all_moves

  end

  def can_jump?
    jump_diffs.each do |diff|
      pos_to_try = [@position[0] + diff[0], @position[1] + diff[1]]
      if perform_jump(pos_to_try)
        return true
      end
    end
    false
  end

  def to_s
    @color == :white ? (@king ? '♔' : '♙') : (@king ? '♚' : '♟')
  end

  def dup
    duped_piece = Piece.new(@position.dup,@color,nil,@king)
  end
end

class IllegalMoveError < StandardError
end
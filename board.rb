class Board

  DIMENSION = 8

  def initialize
    @grid = Board.generate_board
  end

  def [](pos)
    x, y = pos[0], pos[1]
    @grid[x][y]
  end

  def []=(pos,piece)
    x, y = pos[0], pos[1]
    @grid[x][y] = piece
  end

  def capture_piece(position)
    self[position] = nil
  end

  def move(start_pos, moves, color)
    # p start_pos
    # p moves
    # p color
    piece = self[start_pos]
    move_precheck(piece,color)
    # p moves
    piece.perform_moves(moves) if piece.valid_move_seq?(moves)
  end

  def pieces
    @grid.flatten.compact
  end

  def forced_to_jump?(color)
    pieces.select { |piece| piece.color == color && piece.can_jump? }.any?
  end

  def move_precheck(piece,color)
    raise "No piece at this position!" if piece.nil?

    unless color == piece.color
      raise "You cannot move your opponent's piece!"
    end
  end

  def update_piece_position(start_pos, end_pos)
    piece = self[start_pos]
    self[end_pos],self[start_pos] = piece, nil
    piece.position = end_pos
  end

  def dup
    # duped board should start empty
    duped_board = Board.new
    @grid.flatten.compact.each do |piece|
      duped_board[piece.position] = piece.dup
      duped_board[piece.position].board = duped_board
    end
    duped_board
  end

  def to_s
    render_board
  end

  def setup_pieces
    DIMENSION.times do |x|
      DIMENSION.times do |y|
        if x < 3
          self[[x,y]] = Piece.new([x,y], :red, self) if (x + y).even?
        end
        if x > 4
          self[[x,y]] = Piece.new([x,y], :white, self) if (x + y).even?
        end
      end
    end
  end

  private

  def self.generate_board
    grid = Array.new(DIMENSION) { Array.new(DIMENSION) }
  end

  def no_valid_moves?(color)
    @grid.flatten.compact.select do |piece|
      piece.color == color
    end.map(&:valid_moves).flatten.empty?
  end

  def render_board

    board_string = ('a'..'h').inject('') { |str, ltr| str += " #{ltr} " } + "\n"

    @grid.reverse.each_with_index do |row, i|
      row.each_with_index do |tile, j|
        icon = (tile.nil? ? ' ' : "#{tile.to_s}")
        color = ((i + j).even? ? :light_red : :light_white)
        board_string << " #{icon} ".colorize(:background => color)
      end
      board_string << " #{DIMENSION - i}\n"
    end

    board_string
  end

end
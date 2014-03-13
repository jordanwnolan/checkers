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

  def move(start_pos, end_pos, color)
    piece = self[start_pos]

    if valid_move?(piece,end_pos,color)
      # move!(dfead)
      piece.position  = end_pos
      self[start_pos], self[end_pos] = nil, piece
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

  private

  def self.generate_board
    grid = Array.new(DIMENSION) { Array.new(DIMENSION) }
  end

  def setup_pieces
    DIMENSION.times do |row|
      DIMENSION.times do |col|

      end
    end
  end

  def valid_move?(piece, end_pos, color)
    raise "No piece at this position!" if piece.nil?

    unless color == piece.color
      raise "You cannot move your opponent's piece!"
    end

    unless piece.moves.include?(end_pos)
      raise "Invalid move for #{piece.color}'s #{piece.class}!"
    end

    if piece.move_into_check?(end_pos)
      raise "cannot move #{piece.color}'s #{piece.class} into check!"
    end

    true
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
        color = ((i + j).even? ? :light_white : :light_red)
        board_string << " #{icon} ".colorize(:background => color)
      end
      board_string << " #{DIMENSION - i}\n"
    end

    board_string
  end

end
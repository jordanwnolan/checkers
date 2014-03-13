class Checkers
  attr_accessor :board

  LETTERS = {'a' => 0,
             'b' => 1,
             'c' => 2,
             'd' => 3,
             'e' => 4,
             'f' => 5,
             'g' => 6,
             'h' => 7,
           }

  def initialize
    @board = Board.new
    @board.setup_pieces
    @current_player = :red
  end

  def play
    puts @board
    begin
      begin
      puts "what piece would you like to move (ex 2,0)"
      piece = parse_input
      puts "enter your move sequence (enter done when sequence is complete)"
      moves = get_move_sequence

        @board.move(piece,moves,@current_player)
      rescue Exception => e
        puts e
        retry
      end
      @current_player = (@current_player == :red ? :white : :red)
      puts @board
    end until piece == 'quit'
  end

  def get_move_sequence
    moves = []
    while true
      move = parse_input
      return moves if move == 'done'
      moves << move
      p moves
    end
  end

  def parse_input
    input = gets.chomp
    return input if input == 'done'
    input = input.split('').map!(&:strip)
    p input
    move = [input[1].to_i - 1,LETTERS.fetch(input[0])]
  end
end
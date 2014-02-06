require_relative "chess_pieces"
require_relative "chess_board"

class Game
  def initialize
    @board = Board.new
  end

  def play
    current_color = :white

    until game_over?
      begin
        display_board
        start, target = get_input
        raise BadMoveError if @board[start[0],start[1]].color != current_color
        if @board.in_check?(current_color) && still_in_check?(start, target,current_color)
          raise BadMoveError.new("You can't move there, you're still in check")
          next
        end

        @board.move(start,target)
        current_color = next_turn(current_color)
      rescue  BadMoveError => e
        puts e.message
      end
    end

    winner = next_turn(current_color)
    puts "Checkmate! #{winner.upcase} wins."
  end

  def display_board
    system("clear")
    puts @board
  end

  def game_over?
    @board.check_mate?(:white) || @board.check_mate?(:black)
  end

  def next_turn(color)
    color == :black ? :white : :black
  end

  def get_input
    puts "Enter start_row, start_col > end_row, end_col:"
    input = gets.chomp.split(">")
    start = input[0].chomp.split(",").map!(&:to_i)
    target = input[1].chomp.split(",").map!(&:to_i)
    [start, target]
  end

  def still_in_check?(start, target, color)
    duped_board = @board.deep_dup_board
    duped_board.move(start, target)
    duped_board.in_check?(color)
  end

end

class BadMoveError< ArgumentError
  def initialize(msg = "You made an illegal move")
    super
  end
end


if __FILE__ == $PROGRAM_NAME
  g = Game.new
  g.play
end

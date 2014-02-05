class Piece
  attr_accessor :pos, :color, :board

  PIECE_SYMBOLS = {:Queen => " Q ", :King => " K ", :Bishop => " B ",
                    :Knight => " T ", :Rook => " R ", :Pawn => " p "}

  def initialize(pos, color, board)
    @pos = pos
    @color = color
    @board = board

  end

  def moves
    raise NotImplementedError
  end

  def make_move(target)
    @pos = target if moves.include?(target)
  end

  def to_s
    PIECE_SYMBOLS[self.class.to_s.to_sym]
  end
end

class SlidingPiece < Piece
  DIAGONALS = [[1,1], [1,-1], [-1,1], [-1,-1]]
  HORIZONTALS = [[0,1], [0,-1], [1,0], [-1,0]]

  def initialize(pos, color, board)
    super
  end

  def moves
    possible_moves = []
    moves_arr.each do |direction|
      8.times do |idx|
        drow = @pos[0] + (idx * direction[0])
        dcol = @pos[1] + (idx * direction[1])
        next if [drow,dcol] == self.pos
        if !@board[drow, dcol].nil?
          break if @board[drow, dcol].color == self.color
        end
        possible_moves << [drow, dcol] if drow.between?(0,7) && dcol.between?(0,7) && [drow,dcol] != [@pos[0],@pos[1]]
        break unless @board[drow, dcol].nil? #########
      end
    end
    possible_moves
  end



end

class Queen < SlidingPiece
  attr_accessor :moves_arr

  def initialize(pos,color,board)
    super
  end

  def moves_arr
    DIAGONALS + HORIZONTALS
  end

end

class Rook < SlidingPiece
  attr_accessor :moves_arr

  def initialize(pos,color,board)
    super
  end

  def moves_arr
    HORIZONTALS
  end

end

class Bishop < SlidingPiece
  attr_accessor :moves_arr

  def initialize(pos,color,board)
    super
  end

  def moves_arr
    DIAGONALS
  end

end

class SteppingPiece < Piece

  KNIGHT = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]
  KING = [[1,0], [-1,0], [0,1], [0,-1], [1,1], [1,-1], [-1,1], [-1,-1]]

  def initialize(pos, color, board)
    super
  end

  def moves
    # p self.class
    # p self.color #############################
    # p self.pos
    # p moves_arr

    return [] if moves_arr.nil?

    possible_moves = []
    moves_arr.each do |move|
      drow = @pos[0] + move[0]
      dcol = @pos[1]+move[1]
      # next unless board[drow,dcol].nil?
      possible_moves << [drow,dcol] if drow.between?(0,7) && dcol.between?(0,7)
    end
    possible_moves
  end

end

class Knight < SteppingPiece

  attr_accessor :moves_arr

  def initialize(pos, color, board)
    super
  end

  def moves_arr
    KNIGHT
  end

end

class King < SteppingPiece

  attr_accessor :moves_arr

  def initialize(pos, color, board)
    super
  end

  def move_arr
    KING
  end

end

class Pawn < Piece

  PAWN_MOVES = {:white => [[-1,0]],
                :black => [[1,0]] }
  START_ROW = {:white => 6, :black => 1}
  PAWN_FIRST = {:white => [[-2,0]], :black => [[2,0]]}
  PAWN_ATTACK = {:white => [[-1,1], [-1,-1]], :black => [[1,1], [1,-1]]}

  def moves
    result = attack_moves + first_moves + reg_moves
    # p result##############
    result
  end

  def attack_moves
    moves = []
    PAWN_ATTACK[self.color].each do |move|
      drow = @pos[0]+move[0]
      dcol = @pos[1]+move[1]
      moves << [drow, dcol] unless @board[drow,dcol].nil? || @board[drow,dcol].color == self.color
    end
    moves
  end

  def first_moves
    moves = []
    PAWN_FIRST[self.color].each do |move|
      drow = @pos[0]+move[0]
      dcol = @pos[1]+move[1]
      blocker = @color == :black ? [@pos[0]+1,@pos[1]] : [@pos[0]-1,@pos[1]]
      moves << [drow,dcol] if @board[drow,dcol].nil? && @pos[0] == START_ROW[self.color] &&
      @board[blocker[0], blocker[1]].nil?
    end
    moves
  end

  def reg_moves
    delta = PAWN_MOVES[self.color][0]
    moves = []
    moves << [@pos[0] + delta[0], @pos[1]] if @board[@pos[0] + delta[0], @pos[1]].nil?
    moves
  end


  # A_WHITE_MOVES = [[-1,1], [-1,-1]]
  # A_BLACK_MOVES = [[1,1], [1,-1]]
  # BLACK_MOVES = [[2,0], [1,0]]
  # WHITE_MOVES = [[-2,0], [-1,0]]
  #
  # def initialize(pos,color,board)
  #   super
  # end
  #
  # def moves
  #   if self.color == :white
  # end
  #
  # def white_move
  #   possible_moves = []
  #   if @pos[0] == 6
  #     drow = WHITE_MOVES.first[0]
  #     dcol = WHITE_MOVES.first[1]
  #     possible_moves << [@pos[0] + drow, @pos[1]] if self.board[[@pos[0] + drow, @pos[1]]].nil?
  #   elsif @pos[0] != 6
  #     drow = WHITE_MOVES.last[0]
  #     dcol = WHITE_MOVES.last[1]
  #     possible_moves << [@pos[0] + drow, @pos[1]] if self.board[[@pos[0] + drow, @pos[1]]].nil?
  #   end
  #
  # end

end
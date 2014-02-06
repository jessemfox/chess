require 'colorize'

class Piece
  attr_accessor :pos, :color, :board

  PIECE_SYMBOLS = {
    :black => {  :Queen => " \u265B ",
                 :King => " \u265A ",
                 :Bishop => " \u265D ",
                 :Knight => " \u265E ",
                 :Rook => " \u265C ",
                 :Pawn => " \u265F "
    },
    :white => {:Queen => " \u2655 ", :King => " \u2654 ", :Bishop => " \u2657 ",
                    :Knight => " \u2658 ", :Rook => " \u2656 ", :Pawn => " \u2659 "}
  }

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
    color = self.color == :white ? :red : :blue
    PIECE_SYMBOLS[self.color][self.class.to_s.to_sym].encode('utf-8').colorize(color)
  end

  def valid_moves?
    self.moves.any? do |move|
      duped_board = @board.deep_dup_board
      duped_board.move(@pos, move)
      !duped_board.in_check?(@color)
    end
  end
end


class SlidingPiece < Piece
  DIAGONALS = [[1,1], [1,-1], [-1,1], [-1,-1]]
  HORIZONTALS = [[0,1], [0,-1], [1,0], [-1,0]]

  def moves
    possible_moves = []

    moves_arr.each do |direction|
      1.upto(7) do |idx|
        drow = @pos[0] + (idx * direction[0])
        dcol = @pos[1] + (idx * direction[1])

        next unless drow.between?(0, 7) && dcol.between?(0, 7)

        piece = @board[drow, dcol]
        break if piece && piece.color == self.color

        possible_moves << [drow, dcol]

        break unless piece.nil?
      end
    end

    possible_moves
  end
end


class Queen < SlidingPiece
  attr_accessor :moves_arr

  def moves_arr
    DIAGONALS + HORIZONTALS
  end
end


class Rook < SlidingPiece
  attr_accessor :moves_arr

  def moves_arr
    HORIZONTALS
  end
end


class Bishop < SlidingPiece
  attr_accessor :moves_arr

  def moves_arr
    DIAGONALS
  end
end


class SteppingPiece < Piece
  def moves
    possible_moves = []

    moves_arr.each do |move|
      drow = @pos[0] + move[0]
      dcol = @pos[1] + move[1]

      next unless drow.between?(0, 7) && dcol.between?(0, 7)
      next if @board[drow, dcol] && @board[drow, dcol].color == @color

      possible_moves << [drow,dcol]
    end

    possible_moves
  end

  def moves_arr
    self.class::STEPS
  end
end


class Knight < SteppingPiece
  STEPS = [[1,2], [1,-2], [-1,2], [-1,-2], [2,1], [2,-1], [-2,1], [-2,-1]]
end


class King < SteppingPiece
  STEPS = [[1,0], [-1,0], [0,1], [0,-1], [1,1], [1,-1], [-1,1], [-1,-1]]
end


class Pawn < Piece
  PAWN_MOVES = {:white => [[-1,0]],
                :black => [[1,0]] }
  START_ROW = {:white => 6, :black => 1}
  PAWN_FIRST = {:white => [[-2,0]], :black => [[2,0]]}
  PAWN_ATTACK = {:white => [[-1,1], [-1,-1]], :black => [[1,1], [1,-1]]}

  def moves
    attack_moves + first_moves + reg_moves
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
    return [] unless self.pos[0] == START_ROW[self.color]

    moves = []

    PAWN_FIRST[self.color].each do |move|
      drow, dcol = @pos[0] + move[0], @pos[1] + move[1]
      blocker = @color == :black ? [@pos[0] + 1, @pos[1]] : [@pos[0] - 1, @pos[1]]
      moves << [drow, dcol] if @board[drow, dcol].nil? && @board[blocker[0], blocker[1]].nil?
    end

    moves
  end

  def reg_moves
    delta = PAWN_MOVES[self.color][0]
    x, y = @pos[0] + delta[0], @pos[1]
    if @board[x, y].nil?
      [[x, y]]
    else
      []
    end
  end
end
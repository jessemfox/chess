require_relative "chess_pieces"
require "colorize"

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    set_up_board
  end

  def set_up_board
    # white_starting_positions = []
    # black_starting_positions = []
    # piece_types = []
    #
    # [[white_starting_positions, :white], [black_starting_positions, :black]].each do |positions, color|
    #   positions.each_with_index do |position, i|
    #     type = piece_types[i]
    #     set_piece(pos[0], pos[1], type.new(pos, color, self))
    #   end
    # end

    set_piece(0, 0, Rook.new([0,0], :black,self))
    set_piece(0, 1, Knight.new([0,1],:black,self))
    set_piece(0, 2, Bishop.new([0,2],:black,self))
    set_piece(0, 3, Queen.new([0,3],:black,self))
    set_piece(0, 4, King.new([0,4],:black,self))
    set_piece(0, 5, Bishop.new([0,5],:black,self))
    set_piece(0, 6, Knight.new([0,6],:black,self))
    set_piece(0, 7, Rook.new([0,7],:black,self))
    set_piece(1, 0, Pawn.new([1,0], :black, self))
    set_piece(1, 1, Pawn.new([1,1], :black, self))
    set_piece(1, 2, Pawn.new([1,2], :black, self))
    set_piece(1, 3, Pawn.new([1,3], :black, self))
    set_piece(1, 4, Pawn.new([1,4], :black, self))
    set_piece(1, 5, Pawn.new([1,5], :black, self))
    set_piece(1, 6, Pawn.new([1,6], :black, self))
    set_piece(1, 7, Pawn.new([1,7], :black, self))

    set_piece(7, 0, Rook.new([7,0], :white, self))
    set_piece(7, 1, Knight.new([7,1], :white, self))
    set_piece(7, 2, Bishop.new([7,2], :white,self))
    set_piece(7, 3, Queen.new([7,3], :white,self))
    set_piece(7, 4, King.new([7,4], :white,self))
    set_piece(7, 5, Bishop.new([7,5], :white,self))
    set_piece(7, 6, Knight.new([7,6], :white,self))
    set_piece(7, 7, Rook.new([7,7], :white,self))
    set_piece(6, 0, Pawn.new([6,0], :white, self))
    set_piece(6, 1, Pawn.new([6,1], :white, self))
    set_piece(6, 2, Pawn.new([6,2], :white, self))
    set_piece(6, 3, Pawn.new([6,3], :white, self))
    set_piece(6, 4, Pawn.new([6,4], :white, self))
    set_piece(6, 5, Pawn.new([6,5], :white, self))
    set_piece(6, 6, Pawn.new([6,6], :white, self))
    set_piece(6, 7, Pawn.new([6,7], :white, self))
  end

  def [](row, col)
    @grid[row][col]
  end


  # Make it take (pos, val)
  def set_piece(row, col, val)
    # row, col = pos
    @grid[row][col] = val
  end

  def to_s
    board_str = ""
    @grid.each_with_index do |row, row_idx|
      board_str << " #{row_idx}|"
      row.each_with_index do |space, space_idx|
        if space.nil?
          board_str << colorize(row_idx, space_idx, "   ")
        else
          board_str << colorize(row_idx, space_idx, space.to_s)
        end

      end
      board_str << "\n"
    end
    board_str << "   "
    8.times {|i| board_str << " #{i} " }
    board_str
  end

  def colorize(row, col, input)
    if (row.even? && col.even?) || (row.odd? && col.odd?)
      input.on_white
    else
      input.on_black
    end
  end

  def in_check?(color)
    king_pos = find_king(color).pos

    pieces_for(other_color(color)).any? do |piece|
      piece.moves.include?(king_pos)
    end
  end

  def find_king(color)
    pieces_for(color).find do |piece|
      piece.is_a?(King)
    end
  end

  def other_color(color)
    color == :black ? :white : :black
  end

  def check_mate?(color)
    pieces_for(color).none?(&:valid_moves?)
  end

  def pieces_for(color)
    self.grid.flatten.select { |piece| piece && piece.color == color }
  end

  def deep_dup_board
    duped_board = self.dup
    # duped_board.grid = Array.new(8) { Array.new(8) }
    duped_board.grid = @grid.map do |row|
      row.map do |piece|
        if piece.nil?
          nil
        else
          new_piece = piece.dup
          new_piece.board = duped_board
          new_piece
        end
      end
    end

    # duped_board.grid.each_with_index do |row, row_idx|
    #   row.each_with_index do |col, col_idx|
    #     piece = @grid[row_idx][col_idx]
    #     col = piece.nil? ? nil : piece.dup
    #     next if col.nil?
    #     col.board = duped_board
    #     duped_board.grid[row_idx][col_idx] = col
    #   end
    # end
    duped_board
  end

  def move(start, target)
    start_piece = self[start[0], start[1]]
    raise BadMoveError if start_piece.nil? || !start_piece.moves.include?(target)
    start_piece.make_move(target)
    set_piece(start[0], start[1], nil)
    set_piece(target[0], target[1], start_piece)
  end
end


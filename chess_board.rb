load "chess_pieces.rb"

class Board

  attr_accessor :grid

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    set_up_board
  end

  def set_up_board
    set_piece(0, 0, Rook.new([0,0], :black,self))
    set_piece(0, 1, Knight.new([0,1],:black,self))
    set_piece(0, 2, Bishop.new([0,2],:black,self))
    set_piece(0, 3, King.new([0,3],:black,self))
    set_piece(0, 4, Queen.new([0,4],:black,self))
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
    set_piece(7, 3, King.new([7,3], :white,self))
    set_piece(7, 4, Queen.new([7,4], :white,self))
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
    return nil if @grid[row].nil?
    @grid[row][col]
  end


  def set_piece(row, col, val)
    @grid[row][col] = val
  end

  def to_s
    board_str = ""
    @grid.each do |row|
      row.each do |space|
        if space.nil?
          board_str << " - "
        else
          board_str << space.to_s
        end

      end
      board_str << "\n"
    end
    board_str
  end

  def in_check?(color)
    king = find_king(color)

    pieces_for(other_color(color)).each do |piece|
      # next if piece.moves.empty?
      return true if piece.moves.include?(king.pos)
    end

    false
  end

  def find_king(color)
    king = nil
    self.grid.each do |row|
      row.each do |space|
        next if space.nil?
        if space.class == King && space.color == color
          king = space
          break
        end
      end
      break if !king.nil?
    end
    king
  end

  def other_color(color)
    color == :black ? :white : :black
  end


  def pieces_for(color)
    found_pieces = []
    self.grid.each do |row|
      row.each do |space|
        next if space.nil?
        found_pieces << space if space.color == color
      end
    end
    found_pieces
  end

  def check_mate?(color)
    return false unless in_check?(color)
    original_pos = find_king(color).pos
    originial_pos.moves do |move|
    end
  end

  def deep_dup_board
    duped_board = self.dup
    duped_grid = []
    self.grid.each do |row|
      duped_row = []
      row.each do |position|
        if posistion.nil?
          duped_row << nil
        else
          duped_piece = position.dup
          duped_piece.board = duped_board
          duped_row << duped_piece
        end
      end
      duped_grid << duped_row
    end
    duped_board
  end

  def valid_moves
    original_pos = find_king(color).pos
    original_pos.moves do |move|
      board = deep_dup_board

    end
  end

  def move(start, target)

    start_piece = self[start[0], start[1]]
    # p start_piece.moves
    # p start_piece.class
    raise NoPieceException if start_piece.nil? || !start_piece.moves.include?(target)
    start_piece.make_move(target)
    set_piece(start[0], start[1], nil)
    set_piece(target[0], target[1], start_piece)
  end


end

class NoPieceException < ArgumentError
  def initialize(msg = "There's no piece there")
    super
  end
end
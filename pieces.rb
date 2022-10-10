# frozen_string_literal: true

class Pieces
  attr_reader :color, :name, :moves
  attr_accessor :position
  def initialize(name, color, _position, moves = [])
    @name = name
    @color = color
    @position = @position
    @moves = moves
  end

  def valid?(position, _moves)
    is_possible?(position) && inside_board?(position)
  end

  def is_possible?(position)
    moves = self.moves
    moves.each do |_move|
      x = self.position[0] + moves[0]
      y = self.position[1] + moves[1]
      return true if position == [x, y]
    end
    # false?
  end

  def inside_board?(position)
    position[0].between?(1, 8) && position[1].between?(1, 8)
  end

  def changing_moved
    @moved = true
  end
end

class Pawn < Pieces
  attr_reader :name, :color, :moves, :eating, :starting_moves
  attr_accessor :position, :moved, :enpassant
  def initialize(name, color, position)
    @name = name
    @color = color
    @position = position
    @moves = [0, 1]
    @eating = [[1, 1], [-1, 1]]
    @starting_moves = [0, 2]
    @moved = false
    @enpassant = false
  end

  def on_enpassant
    @enpassant = true
  end

  def off_enpassant
    @enpassant = false
  end
end

class BlackPawn < Pawn
  attr_reader :name, :color, :moves, :eating, :starting_moves
  attr_accessor :position, :moved, :enpassant
  def initialize(name, color, position)
    @name = name
    @color = color
    @position = position
    @moves = [0, -1]
    @eating = [[1, -1], [-1, -1]]
    @starting_moves = [0, -2]
    @moved = false
    @enpassant = false
  end
end

class Tower < Pieces
  attr_reader :color, :name, :moves
  attr_accessor :position, :castling, :moved
  def initialize(name, color, position, moves)
    @name = name
    @color = color
    @position = position
    @moves = moves
    @moved = false
    @castling = true
    # I have to put on starting_moves the rook possibilitie.
  end
end

class Knight < Pieces
end

class Bishop < Pieces
end

class King < Pieces
  attr_reader :color, :name, :moves
  attr_accessor :position, :castling, :moved, :check
  def initialize(name, color, position, moves)
    @name = name
    @color = color
    @position = position
    @moves = moves
    @moved = false
    @castling = true
    @check = false
    # I have to put on starting_moves the rook possibilitie.
  end

  def check_on_off
    @check = @check != true
  end
end

class Queen < Pieces
  def queen_valid?; end
end

# I may put enpassant as a boolean variable so other pieces can read it.
# Remember to create the possibility of transformation for
# the pawn at the end of the board

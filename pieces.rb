class Pieces
    def initialize(name,color)
        @name=name
        @color = color
        @position = nil
        @moves= nil
    end

end


class Pawn < Pieces
end

class Tower < Pieces
end

class Knight < Pieces
end

class Bishop < Pieces
end

class King < Pieces
end

class Queen < Pieces
end
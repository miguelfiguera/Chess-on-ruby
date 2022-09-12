class Pieces
    attr_reader :color, :name, :position, :moves
    def initialize(name,color,position,moves=[])
        @name=name
        @color = color
        @position = @position
        @moves= moves
    end

end

class Pawn < Pieces
    attr_reader :name,:color,:position,:move,:eating
    def initialize (name,color,position)
        @name=name
        @color = color
        @position = position
        @move= [0,1]
        @eating=[[1,1],[-1,1]]
    end

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
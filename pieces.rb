class Pieces
    attr_reader :color, :name, :moves
    attr_accessor :position
    def initialize(name,color,position,moves=[])
        @name=name
        @color = color
        @position = @position
        @moves= moves
    end

    def valid?(position)
        is_possible?(position) && inside_board?(position)
    end

    def is_possible?(position)
        @moves.each do |move|
            x=self.position[0] + moves[0]
            y=self.position[1]+moves[1]
            return true if [x,y] == position
        end
    end

    def inside_board?(position)
        position[0].between?(1,8) && position[1].between?(1,8)
    end

end

class Pawn < Pieces
    attr_reader :name,:color,:moves,:eating, :starting_moves
    attr_accessor :position, :moved
    def initialize (name,color,position)
        @name=name
        @color = color
        @position = position
        @moves= [0,1]
        @eating=[[1,1],[-1,1]]
        @starting_moves = [[0,2],[0,1]]
        @moved=false
    end

    def changing_moved
        @moved = true
    end

end

class Tower < Pieces
    #remember de rook (enroque) of the king.
end

class Knight < Pieces
    #remember the rook as a possibility.


    def check
    end

    def check_mate
    end
end

class Bishop < Pieces
end

class King < Pieces
end

class Queen < Pieces

    def queen_valid?
    end
end
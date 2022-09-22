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
        result=false
        @moves.each do |move|
            x=self.position[0] + moves[0]
            y=self.position[1]+moves[1]
            result= true if [x,y] == position
        end
        result
    end

    def inside_board?(position)
        position[0].between?(1,8) && position[1].between?(1,8)
    end

end

class Pawn < Pieces
    attr_reader :name,:color,:move,:eating, :starting_move
    attr_accessor :position, :moved
    def initialize (name,color,position)
        @name=name
        @color = color
        @position = position
        @moves= [0,1]
        @eating=[[1,1],[-1,1]]
        @starting_move = [0,2]
        @moved=false
    end


    def pawn_valid?
    end

end

class Tower < Pieces
    #remember de rook (enroque) of the king.
end

class Knight < Pieces
    #remember the rook as a possibility.
end

class Bishop < Pieces
end

class King < Pieces
end

class Queen < Pieces

    def queen_valid?
    end
end
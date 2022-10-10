require 'pry-byebug'

class Squares
    attr_accessor :piece, :display
    attr_reader :position

    @@squares_instances=[]

    def initialize(position,piece=nil)
        @position = position
        @piece = piece
        @display = nil
        @@square_instances.push(self)
    end

    def changing_display
        case
        when square.piece.is_a?(King)
        @display = "\u265A" if square.piece.color == 'black'
        @display = "\u2654" if square.piece.color == 'white'
        when square.piece.is_a?(Queen)
        @display = "\u265B" if square.piece.color == 'black'
        @display = "\u2655" if square.piece.color == 'white'
        when square.piece.is_a?(Pawn)
        @display = "\u265f" if square.piece.color == 'black'
        @display = "\u2659" if square.piece.color == 'white'
        when square.piece.is_a?(Tower)
        @display = "\u265C" if square.piece.color == 'black'
        @display = "\u2656" if square.piece.color == 'white'
        when square.piece.is_a?(Bishop)
        @display = "\u265d" if square.piece.color == 'black'
        @display = "\u2657" if square.piece.color == 'white'
        when square.piece.is_a?(Knight)
        @display = "\u265e" if square.piece.color == 'black'
        @display = "\u2658" if square.piece.color == 'white'
        when square.piece == nil
       @display="   ".on_white if (square.position[0] + square.position[1]).odd?
       @display="   ".on_black if (square.position[0] + square.position[1]).even?
        end
    end
    

    def actualize_display
        @@square_instances.each {|sq| sq.changing_display}
    end


    def print
        case 
        when square.piece == nil && square.position[0].between?(1,7)
            num = square.position[0] + square.position[1]
            string = "|   "
            print string.on_black if num.even? 
            print string.on_white if num.odd?
        when square.piece == nil && square.position[0] == 8
            num = square.position[0] + square.position[1]
            string = "|   |"
            print string.on_black if num.even? 
            print string.on_white if num.odd?
        when square.piece != nil && square.position[0].between?(1,7)
            string = "| #{square.display}"
            print string.on_black if num.even? 
            print string.on_white if num.odd?
        when square.piece != nil && square.position[0] == 8
            string = "| #{square.display}|"
            print string.on_black if num.even? 
            print string.on_white if num.odd?
    end


#to print display methods:

end
end
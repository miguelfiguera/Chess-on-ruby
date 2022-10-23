require 'pry-byebug'
require 'colorize'

class Squares
    attr_accessor :piece, :display
    attr_reader :position

    @@square_instances=[]

    def initialize(position,piece=nil)
        @position = position
        @piece = piece
        @display = nil
        @@square_instances.push(self)
    end

    def changing_display
        case
        when self.piece.is_a?(King)
        @display = "\u265A" if self.piece.color == 'black'
        @display = "\u2654" if self.piece.color == 'white'
        when self.piece.is_a?(Queen)
        @display = "\u265B" if self.piece.color == 'black'
        @display = "\u2655" if self.piece.color == 'white'
        when self.piece.is_a?(Pawn)
        @display = "\u265f" if self.piece.color == 'black'
        @display = "\u2659" if self.piece.color == 'white'
        when self.piece.is_a?(Tower)
        @display = "\u265C" if self.piece.color == 'black'
        @display = "\u2656" if self.piece.color == 'white'
        when self.piece.is_a?(Bishop)
        @display = "\u265d" if self.piece.color == 'black'
        @display = "\u2657" if self.piece.color == 'white'
        when self.piece.is_a?(Knight)
        @display = "\u265e" if self.piece.color == 'black'
        @display = "\u2658" if self.piece.color == 'white'
        when self.piece == nil
       @display="   ".on_white if (self.position[0] + self.position[1]).odd?
       @display="   ".on_black if (self.position[0] + self.position[1]).even?
        end
    end


    def prints
        num = self.position[0] + self.position[1]
        display = self.display
        case 
        when self.piece == nil && self.position[0].between?(1,7)
            string = "|   "
            print string.on_black.chomp if num.even? 
            print string.on_white.chomp if num.odd?
        when self.piece == nil && self.position[0] == 8
            string = "|   |\n"
            print string.on_black if num.even? 
            print string.on_white if num.odd?
        when self.piece != nil && self.position[0].between?(1,7)
            string = "| #{display}"
            print string.on_black.chomp if num.even? 
            print string.on_white.chomp if num.odd?
        when self.piece != nil && self.position[0] == 8
            string = "| #{display}|\n"
            print string.on_black if num.even? 
            print string.on_white if num.odd?
        end
    end


#to print display methods:

end

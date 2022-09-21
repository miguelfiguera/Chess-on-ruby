class Squares
    attr_accessor :piece
    attr_reader :position

    def initialize(position,piece=nil)
        @position = position
        @piece = piece
    end
end
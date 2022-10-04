class Squares
    attr_accessor :piece
    attr_reader :position

    @@squares_instances=[]

    def initialize(position,piece=nil)
        @position = position
        @piece = piece
        @@square_instances.push(self)
    end
end
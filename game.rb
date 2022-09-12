require_relative '../pieces.rb'
require_relative '../display.rb'

class Game
    @@white_instances=[]
    @@black_instances=[]
    @@death_ones=[]


    def initialize
        @display=Display.new
    end


    #The pieces...

    def all_the_pieces
    end

    def create_black_pieces
    end

    def create_white_pieces
    end

    #Pieces one by one

    def pawn 
    end

    def tower 
    end

    def knight 
    end

    def bishop 
    end

    def king 
    end

    def queen
    end

    # MOVES

    #valid? piece by piece.

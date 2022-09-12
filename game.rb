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
        create_black_pieces
        create_white_pieces
    end

    def create_black_pieces
    end

    def create_white_pieces
    end

    #Pieces one by one

    def pawn(name,color,position)
        Pawn.new(name,color,position)
    end

    def creating_all_pawns(starting,ending,color)
    end

    def tower(name,color,position,moves=[0,1],[1,0])
        Tower.new(name,color,position,moves)
    end

    def knight(name,color,position,moves=[[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]])
    Knight.new(name,color,position,moves)
    end

    def bishop(name,color,position,moves=[[1,1],[-1,-1],[-1,1],[1,-1]])
        Bishop.new(name,color,position,moves)
    end

    def king(name,color,position,moves=[[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,-1],[-1,1]])
        King.new(name,color,position,moves)
    end

    def queen(name,color,position,moves=[x,y])
        Queen.new(name,color,position,moves)
    end

    # MOVES

    #valid? piece by piece.

    def occupied?
        #check 
    end

    def pawn_valid?
    end

    def tower_valid?
    end
    
    def knight_valid?
    end

    def bishop_valid?
    end

    def king_valid? 
    end

    def queen_valid?
    end

end
require_relative '../pieces.rb'
require_relative '../display.rb'

class Game
    @@white_instances=[]
    @@black_instances=[]
    @@squares_instances=[]
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

    def the_pushing(color,piece)
       @@white_instances.push(piece) if color == 'white'
       @@black_instances.push(piece) if color == 'black'
    end

    def pawn(name,color,position)
        Pawn.new(name,color,position)
    end

    def creating_all_pawns(color)
        starting=nil
        ending = nil
        if color = 'black'
            starting=[1,6]
            ending=[8,6]
        elsif color = 'white'
            starting=[1,2]
            ending = [8,2]
        end
        
        letter= 'P'
        loop do |pawn|
            name = letter + starting[0].to_s
            position = starting 
            Pawn.new(name,color,position)
            break if starting == ending
            starting[0] +=1
        end
    end



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

    def queen(name,color,position,moves=[[0,y],[0,y],[x,0],[x,0],[x,y],[x,y],[x,y],[x,y]])
        Queen.new(name,color,position,moves)
    end

    # MOVES

    #valid? piece by piece.

    def occupied?
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

    def free_path_queen?
    end

    def free_path_tower?
    end

    def free_path_bishop?
    end

    def free_path_select?
    end


    #Finding a Piece
    def finding_piece(name,color)
        arr1=@@white_instances
        arr2=@@black_instances
        result=nil

        if color == 'white'
            arr1.each do |piece|
                result = piece if name == piece.name
            end

        return result if !result.nil?
        elsif color == 'black'
        arr2.each do |piece|
            result= piece if name == piece.name
        end

        return result if !result.nil?
     end
    end

    end

    def killing_a_piece(position)
        finding_piece_for_killing(position)
    end

    def finding_piece_for_killing(position)
        arr1= @@black_instances 
        arr2= @@white_instances
        target_index=nil
        arr1.each_with_index do |piece,index|
            target_index=index if piece.position == position
        end

        return target_index if target_index != nil

        arr2.each_with_index do |piece,index|
            target_index=index if piece.position==position
        end.

        return target_index if !target_index.nil?
    end

end
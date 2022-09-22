require_relative '../pieces.rb'
require_relative '../display.rb'
require 'pry-byebug'

class Game

    attr_accessor :display, :white_instances, :black_instances, :death_ones, :player1, :player2, :current_player

    def initialize
        @display=Display.new
        @white_instances=[]
        @black_instances=[]
        @squares_instances=[]
        @death_ones=[]
        @player1=create_a_player('white')
        @player2=create_a_player('black')
        @current_player=nil
    end

    #players
    def create_a_player(color)
    name = gets.chomp 
    Player.new(name,color)
    end

    def swap_player
        @current_player == @player1 ? @current_player=@player2 : @current_player=@player1
    end

    #The pieces...

    def all_the_pieces
        create_black_pieces
        create_white_pieces
    end

    def create_black_pieces
        color='black'
        creating_all_pawns(color)
        knight('K2',color,[7,8])
        knight('K1',color,[2,8])
        tower('T2',color,[8,8])
        tower('T1',color,[1,8])
        bishop('B1',color,[3,8])
        bishop('B2',color,[6,8])
        queen('Q',color,[4,8])
        king('K',color,[5,8])
    end

    def create_white_pieces
        color = 'white'
        creating_all_pawns('white')
        knight('K2',color,[7,1])
        knight('K1',color,[2,1])
        tower('T2',color,[8,1])
        tower('T1',color,[1,1])
        bishop('B1',color,[3,1])
        bishop('B2',color,[6,1])
        queen('Q',color,[4,1])
        king('K',color,[5,1])
    end

    #Pieces one by one

    def the_pushing(piece,color)
       @white_instances.push(piece) if color == 'white'
       @black_instances.push(piece) if color == 'black'
    end

    def pawn(name,color,position)
        the_pawn=Pawn.new(name,color,position)
        the_pushing(the_pawn,color)
    end

    def creating_all_pawns(color)
        starting=nil
        ending = nil
        if color = 'black'
            starting=[1,7]
            ending=[8,7]
        elsif color = 'white'
            starting=[1,2]
            ending = [8,2]
        end
        
        letter= 'P'
        loop do |pawn|
            name = letter + starting[0].to_s
            position = starting 
            pawn(name,color,position)
            break if starting == ending
            starting[0] +=1
        end
    end

    def tower(name,color,position,moves=[0,1],[1,0])
        the_tower=Tower.new(name,color,position,moves)
        the_pushing(the_tower,color)
    end

    def knight(name,color,position,moves=[[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]])
    the_knight=Knight.new(name,color,position,moves)
    the_pushing(the_knight,color)
    end

    def bishop(name,color,position,moves=[[1,1],[-1,-1],[-1,1],[1,-1]])
        the_b=Bishop.new(name,color,position,moves)
        the_pushing(the_b,color)
    end

    def king(name,color,position,moves=[[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,-1],[-1,1]])
        the_k=King.new(name,color,position,moves)
        the_pushing(the_k,color)
    end

    def queen(name,color,position,moves=[[0,y],[0,y],[x,0],[x,0],[x,y],[x,y],[x,y],[x,y]])
        the_quinn=Queen.new(name,color,position,moves)
        the_pushing(the_quinn,color)
    end

    # MOVES

    #valid? piece by piece.

    def occupied?(position)
        @squares_instances.each do |sp|
            return true if sp.position == position && sp.piece != nil
        end
        false 
    end

    def occupied?()
    
    end

    def my_select(ending)
    
    end




    def free_path_select?
    end


    #Finding a Piece
    def finding_piece(name,color)
        arr1=@white_instances
        arr2=@black_instances
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
        arr1= @black_instances 
        arr2= @white_instances
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

    # SQUARES METHODS

    def array_of_positions(board = [], x = 1, y = 1)
            loop do
              arr = [x, y]
              board.push(arr)
              y += 1 if x == 8
              x == 8 ? x = 1 : x += 1
              break if board[-1] == [8, 8]
              break if board.length > 63
            end
            board
          end
    end

    def create_squares
        array = array_of_positions
        array.each {|position| @squares_instances.push(Squares.new(position))}
    end

    def actualize_piece
        all_piece_instances=@black_instances + @white_instances
        @squares_instances.each do |square|
            all_piece_instances.each do |piece|
                piece.position == square.position ? square.piece = piece : square.piece = nil
            end
        end
    end

end
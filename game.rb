require_relative '../pieces.rb'
require_relative '../display.rb'
require 'pry-byebug'

class Game

    attr_accessor :display, :white_instances, :black_instances, :death_ones, :player1, :player2, :current_player,:current_piece

    def initialize
        @white_instances=[]
        @black_instances=[]
        @squares_instances=[]
        @death_ones=[]
        @player1=create_a_player('white')
        @player2=create_a_player('black')
        @current_player=nil
        @current_piece=nil
    end

    #players
    def create_a_player(color)
        name = gets.chomp 
        Player.new(name,color)
    end

    def swap_player
        @current_player == @player1 ? @current_player=@player2 : @current_player=@player1
    end

    #PIECES

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

    def moves
        piece_selection
        if @current_piece.is_a?(King) || @current_piece.is_a?(Tower)
            puts 'Please selec: castling or move? c/m' if @current_piece.castling == true
            answer=gets.chomp.downcase
            castling if answer == 'c'
            moving_the_piece(@current_piece) if answer == 'm'
        elsif @current_piece.is_a?(Pawn)

            #insert here the enpassant part.

        else
            moving_the_piece(@current)
        end
    end


    def piece_selection
        puts "Select your piece #{@current_player.name}."
        name=gets.chomp.upcase
        @current_piece=finding_piece(name,@current_player.color)
    end

    def moving_the_piece(current_piece)
        puts "Select new position. Example 'x,y' where 'x' & 'y' are integers"
        new_position = new_position_string
        moving_the_piece(current_piece) if !new_position.is_a?(array)
        case 
        when current_piece.is_a?(Pawn) && current_piece.moved==true
           if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
            current_piece.position =new_position
            current_piece.off_enpassant
           else
            puts "Not a valid move, try again."
            moving_the_piece(current_piece)
           end
        when current_piece.is_a?(Pawn) && current_piece.moved==false
            if current_piece.valid?(new_position,current_piece.starting_moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
                current_piece.changing_moved
                current_piece.on_enpassant
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(Tower) && current_piece.moved == true 
            if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(Tower) && current_piece.moved==false
            if current_piece.valid?(new_position,current_piece.starting_moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
                current_piece.changing_moved
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(Knight)
            current_piece.position = new_position if valid?(new_position,current_piece.moves)
        when current_piece.is_a?(Bishop)
            if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(King) && current_piece.moved == true
            if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(King) && current_piece.moved==false
            if current_piece.valid?(new_position,current_piece.starting_moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
                current_piece.changing_moved
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(Queen)
            if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)

        else
            puts 'Invalid input, try again'
        end
    end

    def new_position_string
        position=gets.chomp
        integers=position.split(',')
        final= integers.map!{ |int| int.to_i}
        final
    end



   #ENPASSANT

   # CASTLING
    def castling
        puts "Select your rook!"
        rook_name=gets.chomp
        rook=finding_piece(rook_name,@current_player.color)
        king = finding_piece('K',@current_player.color)
        if checking_empty_squares(@current_player,rook) != true || checking_castling(king,rook) != true 
            puts 'Not a valid move, my friend.'
            return
        else
            moving_castling_pieces(king,rook)
        end
    end

    def checking_empty_squares(current_player,rook)
        case 
        when current_player.color == 'white' && rook.name == 'T2'
            arr[[7,1],[6,1]]
            checking_emptyness_castling(arr)
        when current_player.color == 'white' && rook.name=='T1'
            arr=[[2,1],[3,1],[4,1]]          
            checking_emptyness_castling(arr)
        when current_player.color == 'black' && rook.name=='T1'
            arr=[[2,8],[3,8],[4,8]]
            checking_emptyness_castling(arr)
        when current_player.color == 'black' && rook.name == 'T2'
            arr[[7,8],[6,8]]
            checking_emptyness_castling(arr)
        end
    end


    def checking_castling(king,rook)
        return false if king.moved == true || rook.moved==true
        return true if king.castling == true && rook.castling == true
    end

    def moving_castling_pieces(king,rook)
        case
        when current_player.color == 'white' && rook.name == 'T2'
            king=finding_piece('K',current_player.color)
            rook=finding_piece('T2',current_player.color)
            king.position = [7,1]
            rook.position = [6,1]
            king.moved = true
            rook.moved = true
        when current_player.color == 'white' && rook.name=='T1'
            king=finding_piece('K',current_player.color)
            rook=finding_piece('T1',current_player.color)
            king.position = [3,1]
            rook.position = [4,1]
            king.moved = true
            rook.moved = true
        when current_player.color == 'black' && rook.name=='T1'
            king=finding_piece('K',current_player.color)
            rook=finding_piece('T1',current_player.color)
            king.position = [3,1]
            rook.position = [4,1]
            king.moved = true
            rook.moved = true
        when current_player.color == 'black' && rook.name == 'T2'
            king=finding_piece('K',current_player.color)
            rook=finding_piece('T2',current_player.color)
            king.position = [7,1]
            rook.position = [6,1]
            king.moved = true
            rook.moved = true
    end

    def checking_emptyness_castling(arr)
        result = []
        arr.each do |square|
            result.push(finding_the_square(square))
        end
        return false if result.any?{|sq| sq.position != nil}
        true
    end

    
    #CHECK AND CHECKMATE
   def check_mate?
   end

   def check?
   end

    def check_whites?
    end

    def check_blacks?
    end

   #other functions to make check work
        
    #FINDING PIECES
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



    #CHECKING BOARD.

    def checking_board(current_piece,ending)
        squares_to_check=creating_array_to_check_board(current_piece,ending)
        result=[]
        squares_to_check.each do |check|
            result.push(check) if free_space?(check)
            result.push(check) if check==ending
            break if free_space?(check) == false && check != ending
        end
        puts "Longest legal move is #{result[-1]}."
    end

    def free_space?(position)
        square=finding_the_square(position)
        return true if square.piece.nil?
        false
    end

    def finding_the_square(position)
        square=nil
        @squares_instances.each do |sq|
            square=sq if position == sq.position
        end
        square
    end

    def valid?(position)
        position[0].between?(1,8) && position[1].between?(1,8)
    end

    def creating_array_to_check_board(piece,ending)
        moves=piece.moves
        array=nil
        moves.each do |move|
            array=checking_board_array(piece,move,ending) if array.include?(ending)
        end
        array
    end

    def checking_board_array(piece,move,ending)
        array=[piece.position]
        loop do |result|
            x=array[-1][0] + move[0]
            y=array[-1][1] + move[1]
            break if !valid?([x,y])
            array.push([x,y])
            break if [x,y]== ending
        end
        array if array.include?(ending)
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
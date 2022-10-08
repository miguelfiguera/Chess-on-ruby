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

    #GAME PREP
    def game_prep
        all_the_pieces 
        create_squares
        @current_player = @player1
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

    def blackpawn(name,color,position)
        the_pawn=BlackPawn.new(name,color,position)
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
            pawn(name,color,position) if color == 'white'
            blackpawn(name,color,position) if color == 'black'
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
        piece_selection unless king_in_check?
        if @current_piece.is_a?(King) && @current_piece.castling == true
            puts 'Please select: castling or move? c/m'
            answer=gets.chomp.downcase
            castling if answer == 'c'
            moving_the_piece(@current_piece) if answer == 'm'
        elsif @current_piece.is_a?(Pawn) && checking_for_enpassant(@current_piece.position)
            puts 'Please select, moving or enpassant? m/e.'
            answer=gets.chomp.downcase
            if answer=='e'
                pawn_enpassant_eating(current_piece)
            else
                moving_the_piece(@current_piece)
        elsif king_in_check?
            puts "Your king is in check, #{@current_player.name}."
            puts "Please select a position where your king does not stay in check."
            loop do
            possible_check_mate=0
            piece_selection
            new_position = new_position_string
            x=invalid_move_check_king(new_position) if @current_piece.is_a?(King)
            x=invalid_move_check_pieces(new_position) if !@current_piece.is_a?(King)
            break if x == true
            possible_check_mate += 1
            check_mate? if possible_check_mate => 3
            end
        elsif @current_piece == 'FORFEIT'
            puts "#{current_player.name} Decides to stop playing..."
            @current_player == @player1? puts "#{@player2.name} Wins!" : puts "#{@player1.name} Wins!"
            forfeit
        else
            moving_the_piece(@current_piece)
        end
    end

    def king_in_check?
        king= finding_piece('K',@current_player.color)
        return true if king.check == true
        false
    end

    def piece_selection
        puts "Select your piece #{@current_player.name}."
        name=gets.chomp.upcase
        return @current_piece=name if name == 'FORFEIT'
        @current_piece=finding_piece(name,@current_player.color)
    end

    def moving_the_piece(current_piece)
        new_position = new_position_string
        moving_the_piece(current_piece) if !new_position.is_a?(array)
        case 
        when current_piece.is_a?(Pawn) && current_piece.moved==true
           if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
            current_piece.position =new_position
            current_piece.off_enpassant
           elsif current_piece.valid?(new_position,current_piece.eating) && checking_board(current_piece,new_position)
            killing_a_piece(new_position) if !free_space?(new_position)
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
                killing_a_piece(new_position) if !free_space?(new_position)
                current_piece.position =new_position
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(Tower) && current_piece.moved==false
            if current_piece.valid?(new_position,current_piece.starting_moves) && checking_board(current_piece,new_position)
                killing_a_piece(new_position) if !free_space?(new_position)
                current_piece.position =new_position
                current_piece.changing_moved
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(Knight)
            current_piece.position = new_position if valid?(new_position,current_piece.moves)
            killing_a_piece(new_position) if !free_space?(new_position)
        when current_piece.is_a?(Bishop)
            if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
                killing_a_piece(new_position) if !free_space?(new_position)
                current_piece.position =new_position
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(King) && current_piece.moved == true
            if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
                killing_a_piece(new_position) if !free_space?(new_position)
                current_piece.position =new_position
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(King) && current_piece.moved==false
            if current_piece.valid?(new_position,current_piece.starting_moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
                killing_a_piece(new_position) if !free_space?(new_position)
                current_piece.changing_moved
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)
               end
        when current_piece.is_a?(Queen)
            if current_piece.valid?(new_position,current_piece.moves) && checking_board(current_piece,new_position)
                current_piece.position =new_position
                killing_a_piece(new_position) if !free_space?(new_position)
               else
                puts "Not a valid move, try again."
                moving_the_piece(current_piece)

         end
    end


    def new_position_string
        puts "Select new position. Example 'x,y' where 'x' & 'y' are integers"
        position=gets.chomp
        integers=position.split(',')
        final= integers.map!{ |int| int.to_i}
        final
    end


   #ENPASSANT

   def pawn_enpassant_eating(current_piece)
    new_position = new_position_string
    eating=which_eating_is?(new_position,current_piece)
    if eating[0] == -1
        target= [current_piece.position[0]+eating[0],current_piece.position[1]]
        killing_a_piece(target)
        current_piece.position = new_position
    elsif eating[0]== 1
        target= [current_piece.position[0]+eating[0],current_piece.position[1]]
        killing_a_piece(target)
        current_piece.position = new_position
    end
   end

   def which_eating_is?(new_position,current_piece)
    result=nil
    current_piece.eating.each do |eating|
       result = eating if eating[0] + current_piece.position[0] == new_position[0]
    end
    result
end

 
   #checking conditions for enpassant

   def checking_for_enpassant(current_piece.position)
    return true if checking_lateral_pawn_left(position) || checking_lateral_pawn_right(position)
    false
   end
   def checking_lateral_pawn_left(position)
    square1=finding_the_square([position[0]+1,position[1]]) unless square1.nil? || !square1.piece.is_a?(Pawn)
    pawn1=square1.piece
    return true if pawn1.enpassant==true
    false
   end
   def checking_lateral_pawn_right(position)
    square1=finding_the_square([position[0]+1,position[1]]) unless square1.nil? || !square1.piece.is_a?(Pawn)
    pawn1=square1.piece
    return true if pawn1.enpassant==true
    false
   end


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
        king=selecting_a_king
        arr=kings_valid_moves(piece).map {|pos_only| pos_only.position}
        num=arr.length
        return true if checking_all_king_moves(king,arr,num)
        false
        #array.length = base case
        # if all the posible moves puts king in check it is a checkmate.
        #REMEMBER TO ERASE THE KINGS AUTOMATIC SELECTION ON CHECK
        #THAT WAS A FOOLISH MISTAKE
    end

    def checking_all_king_moves(king,arr,num)
        result=[]
        pieces_that_check_king=[]
        arr.each do |e|
            x=checking_pieces_for_check(king,e)
            result<<x if x==true
            break if result.length == num && result.all?(true)
        end
        return true if result.all?(true) && result.length==num
    end

    def check?
        king=selecting_a_king
        ending=king.position
        ok = checking_pieces_for_check(king,ending)
        return true if ok
    end

    def invalid_move_check_king(new_position)
        king=finding_piece('K',@current_player.color)
        ok = checking_pieces_for_check(king,new_position)
        puts "INVALID MOVE, PUTS KING IN CHECK, TRY AGAIN" if ok
        puts "Valid move, proceed." if !ok
        return true if !ok
        return false if ok
    end

    def invalid_move_check_pieces(new_position)
        previous=[]
        previous<<@current_piece.position
        @current_piece.position = new_position
        if check? 
            return true
        elsif !check?
            @current_piece.position=previous[0]
            return false
        end
    end



    def kings_valid_moves(piece)
        result=[]
        current_piece.moves.each do |move|
            x= move[0]+current_piece.position[0]
            y= move[1]+current_piece.position[1]
            result<<sq=finding_the_square([x,y]) if sq.piece == nil || sq.piece.color != current_piece.color
        end
        result
    end

    def selecting_a_king
        color = nil
        @current_player.color = 'black' ? color='white' : color='black'
        piece = finding_piece('K',color)
        piece
    end

    def checking_pieces_for_check(king,ending)
        x=nil
        @current_player.color == 'black' ?  array=@black_instances : array=@white_instances
        array.each do |pieces|
            x=checking_board(pieces,final)
            king.check = true if x == true
            king.check = false if x == false
            break if x==true
        end
        x
    end

        
   #PAWN PROMOTION

    def promoting_pawn?(current_piece)
        return if !current_piece.is_a?(Pawn)
        return true if current_piece.color == 'white' && current_piece.position[1] = 8
        return true if current_piece.color == 'black' && current_piece.position[1] = 1
        false
    end

    def selecting_promotion(current_piece)
        valid_answers=['q','t','k','b']
        puts 'Select your promotion: T for Rook, K for knight, B for bishop, Q for Queen.'
        puts 'Your Promoted Pawn will conserve his name.'
        answer=gets.chomp.downcase
        if !valid_answers.include?(answer)
            puts "Invalid answer, try again."
            answer=gets.chomp.downcase
        end

        case
        when answer='t'
            new_piece = tower(current_piece.name,@current_player.color,@current_piece.position)
            new_piece.changing_moved
        when answer='k'
            new_piece= knight(current_piece.name,@current_player.color,@current_piece.position)
        when answer='b'
            new_piece=bishop(current_piece.name,@current_player.color,@current_piece.position)
        when answer='q'
            new_piece=queen(current_piece.name,@current_player.color,@current_piece.position)
        end

        erasing_a_piece(@current_piece)
        current_piece = new_piece
    end

    #FINDING PIECES / Killing Pieces
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

    def finding_piece_by_square(ending_position)
        square=finding_the_square(ending_position)
        piece=square.piece
        piece
    end

    def erasing_a_piece(the_piece)
        target_index=finding_piece_index(the_piece.position)
        @white_instances.deleted_at(target_index) if the_piece.color == 'white'
        @black_instances.deleted_at(target_index) if the_piece.color == 'black'
        @current_piece.position=nil
        @current_piece=nil
    end

    def killing_a_piece(position)
        target_index=finding_piece_index(position)
        target_for_confirmation=finding_piece_by_square(position)
        return if @current_piece.color == target_for_confirmation.color
        @white_instances.deleted_at(target_index) if @current_player.color == 'black'
        @black_instances.deleted_at(target_index) if @current_player.color == 'white'
        target_for_confirmation.position==nil
        @death_ones<<target_for_confirmation
    end

    def finding_piece_index(position)
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
            break if check==ending
            break if free_space?(check) == false && check != ending
        end
        puts "Longest legal move is #{result[-1]}."
        true if result[-1] == ending
    end

    def free_space?(position)
        square=finding_the_square(position)
        return true if square.piece==nil
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
        array=[]
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


    #TURNS
    def turns 
     moves
        check?
        check_mate?
        promoting_pawn?
        swap_player 
        actualize_piece
    end


    #SAVING GAME methods 
def saving_game
    saved_game = File.new('saved_game.json','w')
    game_specs = JSON.dump({
        :white_instances => @white_instances
        :black_instances => @black_instances
        :squares_instances => @squares_instances
        :death_ones => @death_ones
        :player1 => @player1
        :player2 => @player2
        :current_player => @current_player
        :current_piece => @current_piece
    })

    saved_game.write(game_specs)
end

    #LOAD GAME methods.
    def load_game
        saved_game = File.read('saved_game.jason')
        loaded=JSON.parse(saved_game)
        @white_instances=loaded['white_instances']
        @black_instances=loaded['black_instances']
        @squares_instances=loaded['squares_instances']
        @death_ones=loaded['death_ones']
        @player1=loaded['player1']
        @player2=loaded['player2']
        @current_player=loaded['current_player']
        @current_piece=loaded['current_piece']
    end



    #Forfeit

    def forfeit
        true if @current_piece == 'FORFEIT'
    end
    


end
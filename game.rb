require_relative 'pieces.rb'
require_relative 'Squares.rb'
require_relative 'display.rb'
require 'colorize'
require 'pry-byebug'

class Game

    attr_accessor :display, :white_instances, :black_instances, :death_ones, :player1, :player2, :current_player,:current_piece

    def initialize
        @white_instances=[]
        @black_instances=[]
        @squares_instances=[]
        @death_ones=[]
        @player1=nil
        @player2=nil
        @current_player=nil
        @current_piece=nil
        @display = Display.new
    end

    #players

    def create_all_players
        puts "Select first player's name"
        @player1=create_a_player('white')
        puts "Select second player's name"
        @player2=create_a_player('black')
    end

    def create_a_player(color)
        name = gets.chomp 
        Player.new(name,color)
    end

    def swap_player
        @current_player == @player1 ? @current_player=@player2 : @current_player=@player1
    end

    #GAME PREP
    def game_prep
        puts "Welcome to this chess game."
        puts 'The rules are the same as ever (if you played chess before)'
        puts 'if you never played chess, use wikipedia.'
        puts 'Important commands: SAVE to save the game.'
        puts 'LOAD to load a previous saved game.'
        puts 'FORFEIT to automatically lose the game...'
        puts 'I hope you enjoy this stuff.'
        create_all_players
        all_the_pieces 
        create_all_squares
        @current_player = @player1
        print_display
        print @black_instances.length
        print @player2
        print @white_instances.length
        print @player1
    end

    #DISPLAY

    def print_display
        actualize_piece
        @squares_instances.each {|sq| sq.changing_display}
        @squares_instances.each {|sq| @display.actualize_display_arrays(sq)}
        @display.print
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

def create_all_squares
    array = array_of_positions
    array.each {|position| @squares_instances.push(Squares.new(position))}
end

def actualize_piece #BFS algorythm
    queue=@black_instances + @white_instances
    until queue.empty?
        piece = queue.shift
        @squares_instances.each {|sq| sq.piece = piece if piece.position == sq.position}
    end
end

    #TURNS
    public

    def turns
        print_display
        moves
        promoting_pawn?(@current_piece)
        print_display
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
        creating_all_pawns(color)
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
        x=1 
        letter= 'P'
        loop do |pawn|
            if color == 'black'
                position= [x,7] 
            elsif color =='white'
                position=[x,2]
            end
            name = letter + x.to_s
            pawn(name,color,position) if color == 'white'
            blackpawn(name,color,position) if color == 'black'
            break if x==8
            x+=1
        end
    end

    def tower(name,color,position,moves=[[0,1],[1,0]])
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

    def queen(name,color,position,moves=[[0,1],[0,-1],[1,0],[-1,0],[1,1],[1,-1],[-1,-1],[-1,1]])
        the_quinn=Queen.new(name,color,position,moves)
        the_pushing(the_quinn,color)
    end

    # MOVES

    def moves
        #I have to separate all of this on different methods
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
            end
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
            check_mate? if possible_check_mate >= 3
            end
        elsif @current_piece == 'FORFEIT'
            puts "#{current_player.name} Decides to stop playing..."
            if @current_player == @player1
                 puts "#{@player2.name} Wins!" 
            else 
                puts "#{@player1.name} Wins!"
            end
            forfeit
        elsif @current_piece == 'SAVE'
            saving_game
        elsif @current_piece == 'LOAD'
            load_game
        else
            moving_the_piece(@current_piece)
        end
    end


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

    def finding_the_square(position)
        square=nil
        @squares_instances.each do |sq|
            square=sq if position == sq.position
        end
        square
    end

    def checking_for_enpassant(position)
        left=[position[0]-1,position[1]]
        right=[position[0]+1,position[1]]
        return true if checking_lateral_pawn(left) || checking_lateral_pawn(right)
        false
    end

    def checking_lateral_pawn(position)
        square1=finding_the_square(position)
        return if square1.nil? || !square1.piece.is_a?(Pawn) || square1.piece.color == @current_player.color
        pawn1=square1.piece
        return true if pawn1.enpassant==true
        false
    end
   
    def king_in_check?
        king= finding_piece('K',@current_player.color)
        return true if king.check == true
        false
    end

    def new_position_string
        puts "Select new position. Example 'x,y' where 'x' & 'y' are integers"
        position=gets.chomp
        integers=position.split(',')
        final= integers.map!{ |int| int.to_i}
        final
    end

    def piece_selection
        puts "Select your piece #{@current_player.name}."
        name=gets.chomp.upcase
        return @current_piece=name if name == 'FORFEIT' || name=='SAVE' || name=='LOAD'
        @current_piece=finding_piece(name,@current_player.color)
    end

 def moving_the_piece(current_piece)
    new_position=new_position_string
    case
    when current_piece.is_a?(Pawn)
        moving_pawn(current_piece,new_position)
    when current_piece.is_a?(Tower)
        moving_rook(current_piece,new_position)
    when current_piece.is_a?(Knight)
        moving_knight(current_piece,new_position)
    when current_piece.is_a?(Bishop)
        moving_bishop(current_piece,new_position)
    when current_piece.is_a?(King)
        moving_king(current_piece,new_position)
    when current_piece.is_a?(Queen)
        moving_queen(current_piece,new_position)
    end
 end

    def moving_pawn(current_piece,new_position)
    end

    def moving_pawn_starting(current_piece,new_position)
    end

    def moving_pawn_normal(current_piece,new_position)
    end

    def moving_rook(current_piece,new_position)
    end

    def moving_knight(current_piece,new_position)
    end

    def moving_bishop(current_piece,new_position)
    end
    
    def moving_king(current_piece,new_position)
    end

    def moving_queen(current_piece,new_position) 
    end


   



    def saving_game
    saved_game = File.new('saved_game.json','w')
    game_specs = JSON.dump({
        :white_instances => @white_instances,
        :black_instances => @black_instances,
        :squares_instances => @squares_instances,
        :death_ones => @death_ones,
        :player1 => @player1,
        :player2 => @player2,
        :current_player => @current_player,
        :current_piece => @current_piece
    })

    saved_game.write(game_specs)
    end

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
end

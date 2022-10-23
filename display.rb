require 'colorize'
require 'pry-byebug'

class Display 
    attr_accessor :one, :two, :three, :four, :five, :six, :seven, :eigth
  def initialize
        @one= Array.new(9){'   '}
        @two= Array.new(9){'   '}
        @three= Array.new(9){'   '}
        @four= Array.new(9){'   '}
        @five= Array.new(9){'   '}
        @six= Array.new(9){'   '}
        @seven= Array.new(9){'   '}
        @eigth= Array.new(9){'   '}
  end


    def print
        puts <<-HEREDOC
        8 | #{@eigth[1]} | #{@eigth[2]} | #{@eigth[3]} | #{@eigth[4]} | #{@eigth[5]} | #{@eigth[6]} | #{@eigth[7]} | #{@eigth[8]} |
        7 | #{@seven[1]} | #{@seven[2]} | #{@seven[3]} | #{@seven[4]} | #{@seven[5]} | #{@seven[6]} | #{@seven[7]} | #{@seven[8]} |
        6 | #{@six[1]} | #{@six[2]} | #{@six[3]} | #{@six[4]} | #{@six[5]} | #{@six[6]} | #{@six[7]} | #{@six[8]} |
        5 | #{@five[1]} | #{@five[2]} | #{@five[3]} | #{@five[4]} | #{@five[5]} | #{@five[6]} | #{@five[7]} | #{@five[8]} |
        4 | #{@four[1]} | #{@four[2]} | #{@four[3]} | #{@four[4]} | #{@four[5]} | #{@four[6]} | #{@four[7]} | #{@four[8]} |
        3 | #{@three[1]} | #{@three[2]} | #{@three[3]} | #{@three[4]} | #{@three[5]} | #{@three[6]} | #{@three[7]} | #{@three[8]} |
        2 | #{@two[1]} | #{@two[2]} | #{@two[3]} | #{@two[4]} | #{@two[5]} | #{@two[6]} | #{@two[7]} | #{@two[8]} |
        1 | #{@one[1]} | #{@one[2]} | #{@one[3]} | #{@one[4]} | #{@one[5]} | #{@one[6]} | #{@one[7]} | #{@one[8]} |


        HEREDOC

    end


    # ACTUALIZING DISPLAY ARRAYS

    def actualize_display_arrays(square)
        actualize_display_array_empty(square) if square.piece == nil
        actualize_display_array_pieces(square) if square.piece != nil
    end


    def actualize_display_array_empty(square)
        position = square.position
        index = position[0]
        string = "   "
        case
        when position[1]==1
            return @one[index] = string.on_black if index.odd?
            @one[index] = string
        when position[1]==2
            return  @two[index] = string.on_black if index.even?
            @two[index] = string
        when position[1]==3
            return @three[index] = string.on_black if index.odd?
            @three[index] = string
        when position[1]==4
            return  @four[index]=  string.on_black if index.even?
            @four[index]=  string
        when position[1]==5
            return @five[index]= string.on_black if index.odd?
            @five[index]= string
        when position[1]==6
            return  @six[index]= string.on_black if index.even?
            @six[index]= string
        when position[1]==7
            return  @seven[index]= string.on_black if index.odd?
            @seven[index]= string
        when position[1]==8
            return @eigth[index]= string.on_black if index.even?
            @eigth[index]= string
        end
    end


    def actualize_display_array_pieces(square)
        position = square.position
        index = position[0]
        case
        when position[1]==1
           return @one[index] = square.display.on_black if index.odd?
            @one[index] = square.display
        when position[1]==2
            return @two[index] = square.display.on_black if index.even?
            @two[index] = square.display
        when position[1]==3
            return @three[index] = square.display.on_black if index.odd?
            @three[index] = square.display
        when position[1]==4
            return  @four[index]=  square.display.on_black if index.even?
            @four[index]=  square.display
        when position[1]==5
            @five[index]= square.display.on_black if index.odd?
            @five[index]= square.display
        when position[1]==6
            return @six[index]= square.display.on_black if index.even?
            @six[index]= square.display
        when position[1]==7
            return @seven[index]= square.display.on_black if index.odd?
            @seven[index]= square.display
        when position[1]==8
            return  @eigth[index]= square.display.on_black if index.even?
            @eigth[index]= square.display
        end

    end

end
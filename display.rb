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

    #There are 9 elements so 
    def actualize_display_array_empty(square)
        position = square.position
        index = position[0]
        case
        when position[1]==1
            @one[index] = square.display.on_black if index.odd?
            @one[index] = square.display
        when position[1]==2
            @two[index] = square.display.on_black if index.even?
            @two[index] = square.display
        when position[1]==3
            @three[index] = square.display.on_black if index.odd?
            @three[index] = square.display
        when position[1]==4
            @four[index]=  square.display.on_black if index.even?
            @four[index]=  square.display
        when position[1]==5
            @five[index]= square.display.on_black if index.odd?
            @five[index]= square.display
        when position[1]==6
            @six[index]= square.display.on_black if index.even?
            @six[index]= square.display
        when position[1]==7
            @seven[index]= square.display.on_black if index.odd?
            @seven[index]= square.display
        when position[1]==8
            @eigth[index]= square.display.on_black if index.even?
            @eigth[index]= square.display
        end
    end


    def actualize_display_array_pieces(square)
        position = square.position
        index = position[0]
        case
        when position[1]==1
            @one[index] = square.display.on_black if index.odd?
            @one[index] = square.display
        when position[1]==2
            @two[index] = square.display.on_black if index.even?
            @two[index] = square.display
        when position[1]==3
            @three[index] = square.display.on_black if index.odd?
            @three[index] = square.display
        when position[1]==4
            @four[index]=  square.display.on_black if index.even?
            @four[index]=  square.display
        when position[1]==5
            @five[index]= square.display.on_black if index.odd?
            @five[index]= square.display
        when position[1]==6
            @six[index]= square.display.on_black if index.even?
            @six[index]= square.display
        when position[1]==7
            @seven[index]= square.display.on_black if index.odd?
            @seven[index]= square.display
        when position[1]==8
            @eigth[index]= square.display.on_black if index.even?
            @eigth[index]= square.display
        end

    end
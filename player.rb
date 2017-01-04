class Player < Creature
    
    def initialize(options={})
        @directions = { left:  { axis: :x, val: -1 }, 
                        right: { axis: :x, val: 1  },
                        down:  { axis: :y, val: 1 },
                        up:    { axis: :y, val: -1  } }
        @keys = { Curses::Key::LEFT => :left, 
                  Curses::Key::RIGHT => :right, 
                  Curses::Key::DOWN => :down, 
                  Curses::Key::UP => :up }
        super
    end
    
    def wait_for_input
        @key = @screen.getch
        if @keys.has_key?(key)
            axis = @directions[@keys[key]][:axis]
            val = @directions[@keys[key]][:val]
            set_cordinates(axis, val)
            if @object[:pos][axis] >= @max[axis] || @object[:pos][axis] < 0
                set_room(axis, val)
                move_to_another_room
            else
                move
            end
        end   
    end
    
    def set_cordinates(axis, val)
        @object[:pos][axis] += val
        unless @object[:pos][axis] >= @max[axis] || @object[:pos][axis] < 0
            can_move = @matrix[@object[:pos][:y]][@object[:pos][:x]].object[:can_move]
            if !can_move
                @object[:pos][axis] -= val
            end
        end
        @prev_pos = axis == :y ? { y: @object[:pos][:y]-val, x: @object[:pos][:x] } :
                                 { y: @object[:pos][:y], x: @object[:pos][:x]-val }
    end
    
    def set_room(axis, val)
        @object[:room_pos][axis] += val
        if @map.room(@object[:room_pos][:y], @object[:room_pos][:x]) &&
           @object[:room_pos][:y] >= 0 && @object[:room_pos][:x] >= 0
            @matrix = @map.room(@object[:room_pos][:y], @object[:room_pos][:x])
            @object[:pos][axis] = val > 0 ? 0 : @max[axis]-1
        else
            @object[:room_pos][axis] -= val
            @object[:pos][axis] -= val
        end
    end
    
    def move_to_another_room
        @map.display_room(@object[:room_pos][:y], @object[:room_pos][:x])
        draw(@object[:sym], @object[:pos][:y], @object[:pos][:x])
    end
    
    attr_reader :key
    # getter for @key is needed in until cycle in App.new
    # getter for @pos in prospective will be needed, for example, 
    # for map constructor in case of collision on map generating stage
    
end
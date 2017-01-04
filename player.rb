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
            move
        end   
    end
    
    def set_cordinates(axis, val)
        @object[:pos][axis] += val
        can_move = @matrix[@object[:pos][:y]][@object[:pos][:x]].object[:can_move]
        if !can_move || @object[:pos][axis] >= @max[axis] || @object[:pos][axis] < 0
            @object[:pos][axis] -= val
        end
        @prev_pos = axis == :y ? { y: @object[:pos][:y]-val, x: @object[:pos][:x] } :
                                 { y: @object[:pos][:y], x: @object[:pos][:x]-val }
    end
    
    attr_reader :key
    # getter for @key is needed in until cycle in App.new
    # getter for @pos in prospective will be needed, for example, 
    # for map constructor in case of collision on map generating stage
    
end
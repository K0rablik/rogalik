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
        @player = '@'
        super
        draw(@player, @pos[:y], @pos[:x])
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
        @pos[axis] += val
        can_move = @matrix[@pos[:y]][@pos[:x]].cell[:can_move]
        if !can_move || @pos[axis] >= @max[axis] || @pos[axis] < 0
            @pos[axis] -= val
        end
        @prev_pos = axis == :y ? { y: @pos[:y]-val, x: @pos[:x] } :
                             { y: @pos[:y], x: @pos[:x]-val }
    end
    
    attr_reader :key
    # getter for @key is needed in until cycle in App.new
    # getter for @pos in prospective will be needed, for example, 
    # for map constructor in case of collision on map generating stage
    
end
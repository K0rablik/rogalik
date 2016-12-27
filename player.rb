class Player
    
    def initialize(options={})
        @pos = { y: Curses.lines/2, x: Curses.cols/2 }
        @max = { y: Curses.lines, x: Curses.cols }
        @directions = { left:  { axis: :x, val: -1 }, 
                        right: { axis: :x, val: 1  },
                        down:  { axis: :y, val: 1 },
                        up:    { axis: :y, val: -1  } }
        @keys = { Curses::Key::LEFT => :left, 
                  Curses::Key::RIGHT => :right, 
                  Curses::Key::DOWN => :down, 
                  Curses::Key::UP => :up }
        @player = '@'
        @screen = options[:screen]
        Curses.setpos(@pos[:y], @pos[:x])
        @screen.addstr(@player)
    end
    
    def move(map)
        Curses.setpos(@pos[:y], @pos[:x])
        @screen.addstr(@player)
        Curses.setpos(@prev_pos[:y], @prev_pos[:x])
        cell = map[@prev_pos[:y]][@prev_pos[:x]].cell[:sym]
        @screen.addstr(cell)
    end
    
    def wait_for_input(map)
        @key = @screen.getch
        if @keys.has_key?(key)
            set_cordinates(map)
            move(map)
        end   
    end
    
    def set_cordinates(map)
        axis = @directions[@keys[key]][:axis]
        val = @directions[@keys[key]][:val]
        @pos[axis] += val
        can_move = map[@pos[:y]][@pos[:x]].cell[:can_move]
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
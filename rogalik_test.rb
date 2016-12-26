class App

    class << self

        def new
            unless @instance
                require 'curses'
                screen = Curses.init_screen
                Curses.noecho
                Curses.curs_set(0)
                Curses.stdscr.keypad = true
                player = Player.new(screen: screen)
                map = Map.new(screen: screen)
                map.read_from_file('map.txt')
                until player.key == 'q'
                    player.wait_for_input(map.matrix)
                    map.display
                    player.move
                    
                end
            end
            @instance ||= self
        end
        
    end
    
end
    
class Player
    
    def initialize(options={})                          # options hash is needed 
        @pos = { y: Curses.lines/2, x: Curses.cols/2 }  # only for setting @screen var
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
    
    def move
        Curses.setpos(@pos[:y], @pos[:x])
        @screen.addstr(@player)
    end
    
    def wait_for_input(map)
        @key = @screen.getch
        if @keys.has_key?(key)
            axis = @directions[@keys[key]][:axis]
            val = @directions[@keys[key]][:val]
            @pos[axis] += val
            cell_pos = map[@pos[:y]][@pos[:x]].cell[:pos]
            can_move = map[@pos[:y]][@pos[:x]].cell[:can_move]
            if @pos == cell_pos && !can_move
                @pos[axis] -= val # if collision is occurred
            elsif @pos[axis] >= @max[axis] || @pos[axis] < 0
                @pos[axis] -= val # walk over map borders, say, to another map
                                  # is not possible yet, so method handles that case like collision
            end
        end        
    end
    
    attr_reader :key, :pos 
    # getter for @key is needed in until cycle in App.new
    # getter for @pos in prospective will be needed, for example, 
    # for map constructor in case of collision on map generating stage
    
end
    
class Cell
    def initialize(options={})
        @cell = { pos: { y: options[:y], x: options[:x] },
                  can_move: options[:can_move], 
                  sym: options[:can_move] ? '.' : '#' }
        @screen = options[:screen]
    end
    
    def refresh
        @screen.clear
        Curses.setpos(@cell[:pos][:y], @cell[:pos][:x])
        @screen.addstr(@cell[:sym])
    end
    
    attr_reader :cell
    # getter for @cell is needed in players wait_for_input method
    # for handling collisions
end
    
class Map
    def initialize(options={})
        @screen = options[:screen]
        @matrix = []
    end
    
    def construct
        yield(@map)
    end
    
    def read_from_file(file)
        @map_to_display = File.read(file).split("\n").join
        @matrix = File.read(file).split("\n")
        @matrix = @matrix.map! { |i| i.split('') }
        @matrix.each_index do |i|
            @matrix[i].each_index do |j|
                condition = @matrix[i][j] == '#'
                @matrix[i][j] = Cell.new(can_move: condition ? false : true,
                                      y: i, x: j, screen: @screen)
            end
        end
        return
    end
    
    def display
        @screen.clear
        Curses.setpos(0,0)
        @screen.addstr(@map_to_display)
    end
    
    attr_reader :matrix
end
    
begin
    App.new
ensure
    Curses.close_screen
end
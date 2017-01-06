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
        @object[:stats] = { HP: [20, 20], DMG: 2, ARM: 1 }
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
            elsif @matrix[@object[:pos][:y]][@object[:pos][:x]][:mob]
                mob = @matrix[@object[:pos][:y]][@object[:pos][:x]][:mob]
                attack(mob, axis, val)
                sidebar = display_sidebar(mob)
                if mob.object[:stats][:HP][0] <= 0
                    mob.die
                end
            else
                move
            end
            sidebar ||= display_sidebar
            sidebar
        end   
    end
    
    def set_room(axis, val)
        @object[:room_pos][axis] += val
        if @map.room(@object[:room_pos][:y], @object[:room_pos][:x]) &&
           @object[:room_pos][:y] >= 0 && @object[:room_pos][:x] >= 0
            @matrix[@object[:pos][:y]][@object[:pos][:x]].delete(:player)
            @matrix = @map.room(@object[:room_pos][:y], @object[:room_pos][:x])
            @object[:pos][axis] = val > 0 ? 0 : @max[axis]-1
            @matrix[@object[:pos][:y]][@object[:pos][:x]][:player] = self
        else
            @object[:room_pos][axis] -= val
            @object[:pos][axis] -= val
        end
    end
    
    def move_to_another_room
        @map.display_room(@object[:room_pos][:y], @object[:room_pos][:x])
        draw(@object[:sym], @object[:pos][:y], @object[:pos][:x])
    end
    
    def display_sidebar(mob=nil)
        y = 1
        @object[:stats].each_pair do |key, val|
            str = "#{key}: #{val.class == Array ? val.join('/') : val}"
            draw(str, y*2, @max[:x]+3)
            y += 1
        end
        if mob
            i = 0
            str = '['
            mob.object[:stats][:HP][1].times do
                i += 1
                str += i > mob.object[:stats][:HP][0] ? '-' : '*'
            end
            str += ']'
            draw(str, y*2, @max[:x]+3)
        end
    end
    
    attr_reader :key
    # getter for @key is needed in until cycle in App.new
    # getter for @pos in prospective will be needed, for example, 
    # for map constructor in case of collision on map generating stage
    
end
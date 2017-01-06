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
        #@object[:in_fight] = false
    end
    
    def wait_for_input
        @key = @screen.getch
        if @keys.has_key?(key)
            axis = @directions[@keys[key]][:axis]
            val = @directions[@keys[key]][:val]
            set_cordinates(axis, val)
            if @matrix[@object[:pos][:y]][@object[:pos][:x]][:mob]
                mob = @matrix[@object[:pos][:y]][@object[:pos][:x]][:mob]
                attack(axis, val, mob)
                if mob.object[:stats][:HP][0] <= 0
                    mob.die
                end
            end
            if @object[:pos][axis] >= @max[axis] || @object[:pos][axis] < 0
                set_room(axis, val)
                move_to_another_room
            else
                move
            end
            display_sidebar
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
    
    def display_sidebar
        y = 1
        @object[:stats].each_pair do |key, val|
            str = "#{key}: #{val.class == Array ? val.join('/') : val}"
            draw(str, y*2, @max[:x]+3)
            y += 1
        end
        #if @object[:state][:in_fight]
            #str = '['
            #i = 0
            #creature.object[:stats][:HP][1].times do
                #if creature.object[:stats][:HP][0] > i
                    #str += '*'
                #else 
                    #str += '-'
                #end
                #i += 1
            #end
            #str += ']'
            #draw(str, (y)*2, @max[:x]+3)
        #end
    end
    
    def set_cordinates(axis, val)
        temp = @object[:pos]
        temp[axis] += val
        #@object[:pos][axis] += val
        unless temp[axis] >= @max[axis] || temp[axis] < 0
            can_move = @matrix[temp[:y]][temp[:x]][:cell].object[:can_move]
            if can_move
                #@object[:pos][axis] -= val
                @matrix[temp[:y]][temp[:x]][:player] = self
                @matrix[@object[:pos][:y]][@object[:pos][:x]].delete(:player)
                @object[:pos] = temp
            end
        end
        @prev_pos = axis == :y ? { y: @object[:pos][:y]-val, x: @object[:pos][:x] } :
                                 { y: @object[:pos][:y], x: @object[:pos][:x]-val }
    end
    
    attr_reader :key, :matrix
    # getter for @key is needed in until cycle in App.new
    # getter for @pos in prospective will be needed, for example, 
    # for map constructor in case of collision on map generating stage
    
end
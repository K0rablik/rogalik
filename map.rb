class Map < View
    def initialize(options={})
        @matrix = []
        @rooms = [[]]
        super
    end
    
    def read_from_file(file)
        @matrix = File.read(file).split("\n")
        @matrix = @matrix.map! { |i| i.split('') }
        construct_map(0, 0, @max[:y], @max[:x])
        @player = Player.new(y: @player_pos[:pos][:y], x: @player_pos[:pos][:x],
                             mapy: @player_pos[:room_pos][:y], mapx: @player_pos[:room_pos][:x],
                             screen: @screen,
                             sym: '@', map: self)
        @rooms[@player_pos[:room_pos][:y]][@player_pos[:room_pos][:x]][@player_pos[:pos][:y]][@player_pos[:pos][:x]][:player] = @player
        @mobs_pos.each do |pos|
            @rooms[pos[:room_pos][:y]][pos[:room_pos][:x]][pos[:pos][:y]][pos[:pos][:x]][:mob] = Mob.new(y: pos[:pos][:y], x: pos[:pos][:x],
                                                                                                         mapy: pos[:room_pos][:y], mapx: pos[:room_pos][:x],
                                                                                                         screen: @screen,
                                                                                                         sym: 'g', map: self)
        end
    end
    
    def construct_room(y, x, ymax, xmax)
        temp = []
        @mobs_pos ||= []
        @matrix.each_index do |i|
            if i <= ymax && i >= ymax - @max[:y]
                temp << []
                @matrix[i].each_index do |j|
                    if j <= xmax && j >= xmax - @max[:x]
                        can_move = @matrix[i][j] == '#' ? false : true
                        posy = i-@max[:y]*y
                        posx = j-@max[:x]*x
                        temp[posy][posx] = {}
                        temp[posy][posx][:cell] = Cell.new(can_move: can_move,
                                                           y: posy, x: posx, 
                                                           screen: @screen)
                        @player_pos = { pos: { y: posy, x: posx },
                                        room_pos: { y: y, x: x } } if @matrix[i][j] == '@'
                        @mobs_pos << { pos: { y: posy, x: posx },
                                       room_pos: { y: y, x: x } } if @matrix[i][j] == 'g'
                    end
                end
            end
        end
        return temp
    end
    
    def construct_map(y, x, ymax, xmax)
        unless @matrix[ymax-@max[:y]].nil?
            unless @matrix[ymax-@max[:y]][xmax-@max[:x]].nil?
                @rooms[y][x] = construct_room(y, x, ymax, xmax)
                xmax += @max[:x]
                x += 1
                construct_map(y, x, ymax, xmax)
            end
            @rooms << []
            xmax = @max[:x]
            x = 0
            ymax += @max[:y]
            y += 1
            construct_map(y, x, ymax, xmax)
        end
    end
    
    def display_room(y, x, player: false)
        room = @rooms[y][x]
        room.each_index do |i|
            room[i].each_index do |j|
                if j < @max[:x] && i < @max[:y]
                    sym = room[i][j][:cell].object[:sym]
                    draw(sym, i, j)
                    if room[i][j][:player]
                        sym = room[i][j][:player].object[:sym]
                        draw(sym, i, j)
                    elsif room[i][j][:mob]
                        sym = room[i][j][:mob].object[:sym]
                        draw(sym, i, j)
                    end
                end
            end
        end
    end
    
    def create_object(mapy, mapx, posy, posx, matrix)
        
    end
    
    def room(y, x)
        unless @rooms[y].nil?
            unless @rooms[y][x].nil?
                return @rooms[y][x]
            end
        end
        return nil
    end
    
    attr_reader :rooms, :player
end
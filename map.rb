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
        @player = Player.new(y: @player_pos[:pos][:y],
                             x: @player_pos[:pos][:x],
                             mapy: @player_pos[:room_pos][:y],
                             mapx: @player_pos[:room_pos][:x],
                             screen: @screen, sym: '@', map: self)
    end
    
    def construct_room(y, x, ymax, xmax)
        temp = []
        @matrix.each_index do |i|
            if i <= ymax && i >= ymax - @max[:y]
                temp << []
                @matrix[i].each_index do |j|
                    if j <= xmax && j >= xmax - @max[:x]
                        can_move = @matrix[i][j] == '#' ? false : true
                        @player_pos = { pos: { y: i-@max[:y]*y, x: j-@max[:x]*x },
                                        room_pos: { y: y, x: x } } if @matrix[i][j] == '@'
                        temp[i-@max[:y]*y][j-@max[:x]*x] = Cell.new(can_move: can_move,
                                                                    y: i-@max[:y]*y, 
                                                                    x: j-@max[:x]*x, 
                                                                    screen: @screen)
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
                    sym = room[i][j].object[:sym]
                    draw(sym, i, j)
                    if { y: i, x: j } == @player_pos[:pos] && 
                       { y: y, x: x } == @player_pos[:room_pos] && player
                        draw(@player.object[:sym], i, j) 
                    end
                end
            end
        end
    end
    
    def room(y, x)
        unless @rooms[y].nil?
            unless @rooms[y][x].nil?
                return @rooms[y][x]
            end
        end
        return nil
    end
    
    attr_reader :matrix, :rooms, :max, :player
end
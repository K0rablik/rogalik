class Map < View
    def initialize(options={})
        @matrix = []
        @rooms = []
        super
    end
    
    def read_from_file(file)
        @matrix = File.read(file).split("\n")
        @matrix = @matrix.map! { |i| i.split('') }
        construct_map(0, 0, @max[:y], @max[:x])
    end
    
    def construct_room(y, x, ymax, xmax)
        temp = []
        @matrix.each_index do |i|
            if i <= ymax && i >= ymax - @max[:y]
                temp << []
                @matrix[i].each_index do |j|
                    if j <= xmax && j >= xmax - @max[:x]
                        can_move = @matrix[i][j] == '#' ? false : true
                        @player_pos = { y: i, x: j } if @matrix[i][j] == '@'
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
            @rooms << []
            @rooms[y][x] = construct_room(y, x, ymax, xmax)
            ymax += @max[:y]
            y += 1
            construct_map(y, x, ymax, xmax)
        end
    end
    
    def display_room(y, x)
        room = @rooms[y][x]
        room.each_index do |i|
            room[i].each_index do |j|
                if j < @max[:x] && i < @max[:y]
                    sym = room[i][j].object[:sym]
                    draw(sym, i, j)
                    if { y: i, x: j } == @player_pos && !@player
                        @player = Player.new(map: self, y: i, x: j, 
                                             mapy: y, mapx: x,
                                             screen: @screen, sym: '@')
                        draw(@player.object[:sym], i, j) 
                    end
                end
            end
        end
    end
    
    attr_reader :matrix, :rooms, :max, :player
end
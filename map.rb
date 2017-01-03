class Map < View
    def initialize(options={})
        @matrix = []
        @rooms = []
        super
    end
    
    def read_from_file(file)
        @matrix = File.read(file).split("\n")
        @matrix = @matrix.map! { |i| i.split('') }
        ymax, xmax = @max[:y], @max[:x]
        y, x = 0, 0
        construct(y, x, ymax, xmax)
    end
    
    def construct(y, x, ymax, xmax)
        temp = []
        @matrix.each_index do |i|
            if i <= ymax && i >= ymax - @max[:y]
                temp << []
                @matrix[i].each_index do |j|
                    if j <= xmax && j >= xmax - @max[:x]
                        condition = @matrix[i][j] == '#'
                        @player_pos = { y: i, x: j } if @matrix[i][j] == '@'
                        temp[i][j] = Cell.new(can_move: condition ? false : true,
                                                 y: i, x: j, screen: @screen)
                    end
                end
            end
        end
        @rooms << []
        @rooms[y][x] = temp
        if @matrix[ymax][0]
            ymax += @max[:y]
            y += 1
            construct(y, x, ymax, xmax)
        end
    end
    
    def display(room)
        room.each_index do |i|
            room[i].each_index do |j|
                if j <= @max[:x] && i <= @max[:y]
                    sym = room[i][j].cell[:sym]
                    draw(sym, i, j)
                end
            end
        end
    end
    
    attr_reader :matrix, :player_pos, :rooms, :max
end
class Map
    def initialize(options={})
        @screen = options[:screen]
        @matrix = []
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
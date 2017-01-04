class View

    def initialize(options={})
        @screen = options[:screen]
        @max = { y: 24, x: 80 }
        @min = { y: 0, x: 0 }
    end
    
    def draw(object, y, x)
        Curses.setpos(y, x)
        @screen.addstr(object)
    end
end
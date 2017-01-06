class IngameObject < View
    def initialize(options={})
        @object = { pos: { y: options[:y], x: options[:x] },
                    sym: options[:sym] }
        super
    end
    
    def draw(y, x, str=nil)
        Curses.setpos(y, x)
        str ? @screen.addstr(str) : @screen.addstr(@object[:sym])
    end
    
    attr_reader :object
end
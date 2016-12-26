class Cell
    def initialize(options={})
        @cell = { pos: { y: options[:y], x: options[:x] },
                  can_move: options[:can_move], 
                  sym: options[:can_move] ? '.' : '#' }
        @screen = options[:screen]
    end
    
    attr_reader :cell
    # getter for @cell is needed in players wait_for_input method
    # for handling collisions
end
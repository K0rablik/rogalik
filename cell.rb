class Cell < IngameObject
    def initialize(options={})
        super
        @object[:can_move] = options[:can_move]
        @object[:sym] = @object[:can_move] ? '.' : '#'
    end
    
end
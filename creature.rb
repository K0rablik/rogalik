class Creature < IngameObject
    def initialize(options={})
        super
        @object[:room_pos] = {}
        @object[:room_pos][:x] = options[:mapx]
        @object[:room_pos][:y] = options[:mapy]
        @map = options[:map]
        @matrix = @map.rooms[0][0]
    end
    
    def move
        draw(@object[:sym], @object[:pos][:y], @object[:pos][:x])
        cell = @matrix[@prev_pos[:y]][@prev_pos[:x]].object[:sym]
        draw(cell, @prev_pos[:y], @prev_pos[:x]) if cell
    end
    
end
class Creature < IngameObject
    def initialize(options={})
        super
        @object[:room_pos] = { y: options[:mapy], x: options[:mapx] }
        @object[:stats] = {}
        @map = options[:map]
        @matrix = @map.rooms[@object[:room_pos][:y]][@object[:room_pos][:x]]
    end
    
    def set_cordinates(axis, val)
        @object[:pos][axis] += val
        creature = self.class.to_s.to_sym.downcase
        unless @object[:pos][axis] >= @max[axis] || @object[:pos][axis] < 0
            can_move = @matrix[@object[:pos][:y]][@object[:pos][:x]][:cell].object[:can_move]
            unless can_move
                @object[:pos][axis] -= val
            else
                @matrix[@object[:pos][:y]][@object[:pos][:y]][creature] = self
                @object[:pos][axis] -= val
                @matrix[@object[:pos][:y]][@object[:pos][:x]].delete(creature)
                @object[:pos][axis] += val
            end
        end
        @prev_pos = axis == :y ? { y: @object[:pos][:y]-val, x: @object[:pos][:x] } :
                                 { y: @object[:pos][:y], x: @object[:pos][:x]-val }
    end
    
    def attack(creature, axis, val)
        creature.object[:stats][:HP][0] -= @object[:stats][:DMG]-creature.object[:stats][:ARM]
        @object[:pos][axis] -= val
    end
    
    def move
        draw(@object[:sym], @object[:pos][:y], @object[:pos][:x])
        cell = @matrix[@prev_pos[:y]][@prev_pos[:x]][:cell].object[:sym]
        draw(cell, @prev_pos[:y], @prev_pos[:x]) if cell
    end
        
end
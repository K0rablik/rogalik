class Creature < IngameObject
    def initialize(options={})
        super
        @object[:room_pos] = { y: options[:mapy], x: options[:mapx] }
        @object[:stats] = {}
        @object[:state] = { dead: false, in_fight: false }
        @map = options[:map]
        @matrix = @map.rooms[@object[:room_pos][:y]][@object[:room_pos][:x]]
    end
    
    #def set_cordinates(axis, val)
        #temp = @object[:pos]
        #temp[axis] += val
        #@object[:pos][axis] += val
        #unless temp[axis] >= @max[axis] || temp[axis] < 0
            #can_move = @matrix[temp[:y]][temp[:x]].object[:can_move]
            #if can_move
                #@object[:pos][axis] -= val
                #@matrix[temp[:y]][temp[:x]]
                #@object[:pos][axis] = temp
            #end
        #end
        #@prev_pos = axis == :y ? { y: @object[:pos][:y]-val, x: @object[:pos][:x] } :
                                 #{ y: @object[:pos][:y], x: @object[:pos][:x]-val }
    #end
    
    def attack(axis, val)
        creature.object[:stats][:HP][0] -= @object[:stats][:DMG]-creature.object[:stats][:ARM]
        @object[:pos][axis] -= val
    end
    
    def move
        draw(@object[:sym], @object[:pos][:y], @object[:pos][:x])
        cell = @matrix[@prev_pos[:y]][@prev_pos[:x]][:cell].object[:sym]
        draw(cell, @prev_pos[:y], @prev_pos[:x]) if cell
    end
    
    #def in_range?(creature)
        #if @object[:pos][:y] - creature.object[:pos][:y] <= 10 &&
           #@object[:pos][:x] - creature.object[:pos][:x] <= 10 &&
           #@object[:room_pos] == creature.object[:room_pos]
            #return true
        #end
        #return false
    #end
        
end
class Mob < Creature
    def initialize(options={})
        super
        @object[:stats] = { HP: [6, 6], DMG: 1, ARM: 0 }
    end
    
    def die
        @matrix[@object[:pos][:y]][@object[:pos][:x]].delete(:mob)
        cell = @matrix[@object[:pos][:y]][@object[:pos][:x]][:cell]
        cell.draw(@object[:pos][:y], @object[:pos][:x])
        @object = nil
    end
end
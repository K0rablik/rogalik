class Mob < Creature
    def initialize(options={})
        super
        @object[:stats] = { HP: [6, 6], DMG: 1, ARM: 0 }
    end
    
end
class Creature < View
    def initialize(options={})
        @map = options[:map]
        @matrix = @map.rooms[0][0]
        @pos = { y: @map.player_pos[:y], x: @map.player_pos[:x] }
        @creature = ''
        super
    end
    
    def move
        draw(@player, @pos[:y], @pos[:x])
        cell = @matrix[@prev_pos[:y]][@prev_pos[:x]].cell[:sym]
        draw(cell, @prev_pos[:y], @prev_pos[:x]) if cell
    end
    
end
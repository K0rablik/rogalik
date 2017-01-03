require 'curses'
require_relative 'cell'
require_relative 'view'
require_relative 'map'
require_relative 'creature'
require_relative 'player'
require_relative 'mob'
@screen = Curses.init_screen
Curses.noecho
Curses.curs_set(0)
Curses.stdscr.keypad = true
Curses.close_screen

#begin
    map = Map.new(screen: @screen)
    map.read_from_file('map.txt')
    #map.display(map.rooms[0][0])
    #player = Player.new(screen: @screen, map: map)
    #until player.key == 'q'
        #player.wait_for_input
    #end
#ensure
    #Curses.close_screen
#end
    
p map.rooms[1][0]
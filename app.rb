class App

    class << self

        def new
            unless @instance
                require 'curses'
                require_relative 'cell'
                require_relative 'map'
                require_relative 'player'
                screen = Curses.init_screen
                Curses.noecho
                Curses.curs_set(0)
                Curses.stdscr.keypad = true
                player = Player.new(screen: screen)
                map = Map.new(screen: screen)
                map.read_from_file('map.txt')
                map.display
                until player.key == 'q'
                    player.wait_for_input(map.matrix)
                    player.move(map.matrix)
                end
            end
            @instance ||= self
        end
        
    end
    
end
require_relative 'app'

App.new

begin
    App.run
ensure
    Curses.close_screen
end
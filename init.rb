require_relative 'app'

begin
    App.new
ensure
    Curses.close_screen
end
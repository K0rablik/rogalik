class View

    def initialize(options={})
        @screen = options[:screen]
        @max = { y: 20, x: 64 }
        @min = { y: 0, x: 0 }
    end
    
end
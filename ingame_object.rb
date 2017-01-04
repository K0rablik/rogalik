class IngameObject < View
    def initialize(options={})
        @object = { pos: { y: options[:y], x: options[:x] },
                    sym: options[:sym] }
        super
    end
    
    attr_reader :object
end
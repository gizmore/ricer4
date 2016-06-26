module ActiveRecord::Magic
  class Param::Name < Param::String
    
    def input_to_value(input)
      super(input)
    end

  end
end

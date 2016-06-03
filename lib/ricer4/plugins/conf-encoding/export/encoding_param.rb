module ActiveRecord::Magic::Param
  class Encoding < Ricer4::Parameter
    
    def input_to_value(input)
      ActiveRecord::Magic::Encoding.by_iso(input)
    end

    def value_to_input(encoding)
      encoding.iso rescue nil
    end

    def validate!(value)
      invalid_type! unless value.is_a?(ActiveRecord::Magic::Encoding)
    end
    
  end
end

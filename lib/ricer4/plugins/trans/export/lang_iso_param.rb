module ActiveRecord::Magic::Param
  class LangIso < Ricer4::Parameter
    
    def default_options; { multiple: false , null: true }; end
    
    def input_to_value(input)
      input.to_s
    end

    def value_to_input(iso)
      iso.to_s
    end
    
    def validate!(iso)
      invalid_type! unless iso.is_a?(::String)
      invalid!(:err_unknown_iso) unless Ricer4::GTrans.new.valid_iso?(iso)
    end

  end
end

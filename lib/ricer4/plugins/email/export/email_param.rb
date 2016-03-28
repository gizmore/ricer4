module ActiveRecord::Magic::Param
  class Email < Ricer4::Parameter
    
    def default_options; { mx:true, blacklist:true, disposable:true }; end

    def display_value(email)
      "<#{email.address.to_s}>"
    end

    def input_to_value(input)
      ValidEmail2::Address.new(input)
    end

    def value_to_input(email)
      email.address.to_s rescue nil
    end

    def validate!(email)
      invalid_type! unless email.is_a?(ValidEmail2::Address)
      invalid!(:err_format) unless email.valid?
      invalid!(:err_mx) if option(:mx) && (!email.valid_mx?)
      invalid!(:err_disposable) if option(:disposable) && email.disposable?
      invalid!(:err_blacklisted) if option(:blacklist) && email.blacklisted?
    end
    
  end
end

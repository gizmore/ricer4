module Ricer4::Plugins::Convert
  class Base < Ricer4::Plugin

    trigger_is :base
    
    has_setting name: :input_charset, permission: :public, scope: :user, type: :charset, default: ActiveRecord::Magic::Param::Charset::BASE64
    has_setting name: :output_charset, permission: :public, scope: :user, type: :charset, default: ActiveRecord::Magic::Param::Charset::BASE64
    
    def input_charset; get_user_setting(sender, :input_charset); end
    def output_charset; get_user_setting(sender, :output_charset); end
    
    has_usage '<charset|named:"input_charset",cli:1> <charset|named:"output_charset",cli:1> <numeric_base|named:"input_base"> <numeric_base|named:"output_base"> <..string|multiple:true..>'
    def execute(inchars, outchars, inbase, outbase, numbers)
      inchars ||= input_charset
      outchars ||= output_charset
      return erply(:err_input_charset_too_small, base: inbase, charset: inchars) if inchars.length < inbase
      return erply(:err_output_charset_too_small, base: outbase, charset: outchars) if outchars.length < outbase
      out = numbers.collect { |number| base_convert(number, inbase, outbase, inchars, outchars) }
      reply out.join(',')
    end
    
    private
    
    def base_convert(number, inbase, outbase, inchars, outchars)
      as_ten = parse_to_base_10(number, inbase, inchars)
      number_to_base_n(as_ten, outbase, outchars)
    end
    
    def parse_to_base_10(number, inbase, inchars)
      result = 0
      number.each_char do |char|
        result *= inbase
        result += inchars.index(char)
      end
      result
    end
    
    def number_to_base_n(number, outbase, outchars)
      result = ''
      loop do
        number, mod = * number.divmod(outbase)
        result = outchars[mod] + result
        break if number == 0
      end
      result
    end

  end
end

module Ricer4::Plugins::Convert
  class Sub < Ricer4::Plugin

    trigger_is :sub

    has_usage '<string|named:"search"> <string|named:"replace"> <message>'
    def execute(search, replace, text)
      reply text.gsub(search, replace)
    end
    
  end
end

module Ricer4::Plugins::Convert
  class Concat < Ricer4::Plugin

    trigger_is :add

    has_usage '<string|named:"prefix"> <..string|named:"postfix"..>'
    def execute(prefix, postfix)
    end
    
  end
end

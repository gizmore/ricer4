module Ricer4::Plugins::Convert
  class Flatten < Ricer4::Plugin

    trigger_is :flatten

    has_usage '<string|cli:1,named:"separator"> <message>'
    def execute(separator=nil, lines)
      separator ||= comma
      reply(Array(lines).join(separator).gsub("\n", separator))
    end
    
  end
end

module Ricer4::Plugins::Convert
  class Split < Ricer4::Plugin

    trigger_is :split
    
    has_usage '<string|cli:1,named:"separator",default:","> <boolean|cli:1,named:"regex",default:false> <message>'
    def execute(separator, regex, line)
      separator = Regexp.new(separator) if regex
      line.split(separator).each do |token|
        reply token
      end
    end
    
  end
end

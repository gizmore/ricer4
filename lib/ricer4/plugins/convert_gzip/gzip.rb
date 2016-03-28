module Ricer4::Plugins::Convert
  class Gzip < Ricer4::Plugin

    trigger_is :gzip
    
    has_usage '<integer|named:"level",cli:1,min:1,max:9,default:6> <message>'
    def execute(level=6, text)
      begin
        z = Zlib::Deflate.new(level)
        reply z.deflate(text, Zlib::FINISH)
      ensure
        z.close
      end
    end

  end
end

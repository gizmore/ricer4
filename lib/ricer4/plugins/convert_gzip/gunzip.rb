module Ricer4::Plugins::Convert
  class Gunzip < Ricer4::Plugin

    trigger_is :gunzip

    has_usage '<message>'
    def execute(text)
      begin
        z = Zlib::Inflate.new
        reply z.inflate(text.force_encoding('binary'))
      ensure
        z.finish
        z.close
      end
    end

  end
end

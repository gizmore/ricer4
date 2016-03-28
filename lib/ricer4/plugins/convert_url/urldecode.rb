module Ricer4::Plugins::Convert
  class Urldecode < Ricer4::Plugin

    trigger_is :urldecode

    has_usage '<message>'
    def execute(text)
      reply URI::decode(text)
    end

  end
end

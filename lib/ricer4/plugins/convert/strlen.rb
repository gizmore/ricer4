module Ricer4::Plugins::Convert
  class Strlen < Ricer4::Plugin

    trigger_is "strlen"

    has_usage '<message>'
    def execute(text)
      reply text.length
    end

  end
end

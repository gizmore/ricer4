module Ricer4::Plugins::Convert
  class Reverse < Ricer4::Plugin

    trigger_is :reverse

    has_usage '<message>'
    def execute(text)
      reply text.reverse
    end

  end
end

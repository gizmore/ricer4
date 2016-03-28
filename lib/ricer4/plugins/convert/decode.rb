module Ricer4::Plugins::Convert
  class Decode < Ricer4::Plugin

    trigger_is :decode

    has_usage '<encoding> <message>'
    def execute(encoding, text)
      reply text.force_encoding(encoding.to_label)
    end

  end
end

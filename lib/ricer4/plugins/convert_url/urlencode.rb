module Ricer4::Plugins::Convert
  class Urlencode < Ricer4::Plugin

    trigger_is :urlencode

    has_usage '<message>'
    def execute(text)
      reply URI::encode_www_form_component(text)
    end

  end
end

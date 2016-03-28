module Ricer4::Plugins::Info
  class Botip < Ricer4::Plugin

    trigger_is :botip

    has_usage
    def execute
      require "open-uri"
      threaded do
        ip = open("http://ipecho.net/plain")
        response = ip.read
        reply response
      end
    end
  end
end

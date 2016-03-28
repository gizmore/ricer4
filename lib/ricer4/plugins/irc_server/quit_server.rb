module Ricer4::Plugins::Server
  class QuitServer < Ricer4::Plugin
    
    trigger_is :quit_server
    connector_is :irc

    has_usage  '<server>', function: :execute
    def execute(server)
      server.disconnect
    end
    
  end
end

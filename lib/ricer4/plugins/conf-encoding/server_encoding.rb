module Ricer4::Plugins::Conf
  class ServerEncoding < Ricer4::Plugin
    
    trigger_is "server.encoding"
    
    has_usage  '', function: :execute_show
    has_usage  '<server>', function: :execute_show

    has_usage  '<encoding>', permission: :ircop, function: :execute_set
    has_usage  '<server> <encoding>', permission: :ircop, function: :execute_set_server
    
    def execute_show(server=nil)
      server ||= self.server
      rply(:msg_show,
        iso: server.encoding.to_label,
        server: server.display_name,
      )
    end

    def execute_set(encoding)
      execute_set_server(server, encoding)
    end
    
    def execute_set_server(server, encoding)
      have = server.encoding
      server.encoding = encoding
      server.save!
      rply(:msg_set,
        :server => server.display_name,
        :old => have.to_label,
        :new => encoding.to_label,
      )
    end

  end
end

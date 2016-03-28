module Ricer4::Plugins::Conf
  class ServerLang < Ricer4::Plugin
    
    trigger_is :slang
    
    has_usage  '', function: :execute_show
    has_usage  '<server>', function: :execute_show

    has_usage  '<locale>', permission: :ircop, function: :execute_set
    has_usage  '<server> <locale>', permission: :ircop, function: :execute_set_server
    
    def execute_show(server=nil)
      server ||= self.server
      rply(:msg_show,
        iso: server.locale.to_label,
        server: server.display_name,
        available: UserLang.available,
      )
    end

    def execute_set(language)
      execute_set_server(server, language)
    end
    
    def execute_set_server(server, language)
      have = server.locale
      server.server = language
      server.save!
      rply(:msg_set,
        :server => server.display_name,
        :old => have.to_label,
        :new => language.to_label,
      )
    end

  end
end

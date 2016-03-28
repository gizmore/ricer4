module Ricer4::Plugins::Exec
  class Exec2 < Ricer4::Plugin
    
    def plugin_install
      install_exec_server unless Ricer4::Server.where(:conector => 'exec').first
    end
    
    def install_exec_server
      byebug
      exec_server = Ricer4::Server.create!({
        :conector => 'exec'
      })
    end
    
  end
end
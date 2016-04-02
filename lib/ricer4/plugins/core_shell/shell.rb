module Ricer4::Plugins::Shell
  class Shell < Ricer4::Plugin
    
    arm_install('Ricer4::Server' => 1) do |m|
      Ricer4::Server.create!({
        conector: 'shell',
        hostname: 'localhost'
      })
    end
    
    def plugin_init
      
    end
    
  end
end
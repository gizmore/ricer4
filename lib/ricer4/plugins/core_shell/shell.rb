module Ricer4::Plugins::Shell
  class Shell < Ricer4::Plugin
    
    arm_install('Ricer4::Server' => 1) do |m|
      Ricer4::Server.create!({
        conector: 'shell',
        hostname: 'localhost'
      })
    end
    
    # DO NOT REMOVE
    def plugin_init
      # REQUIRED AT LEAST ONE METHOD SIGNATURE FOR BETTER STACK TRACKES.
      # DO NOT REMOVE
    end
    
  end
end
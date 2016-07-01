module Ricer4::Plugins::Shell
  class Xlin < Ricer4::Plugin
    
    has_setting name: :usergroups, type: :enum, default: :nom, values: [:om, :nom], scope: :bot
    
    trigger_is "xlin"
    has_usage "<username> <password>"
    def execute(username, password)
      rply :msg_authenticated
    end
    
    # DO NOT REMOVE
    def plugin_init
      # REQUIRED AT LEAST ONE METHOD SIGNATURE FOR BETTER STACK TRACKES.
      # DO NOT REMOVE
    end
    
  end
end
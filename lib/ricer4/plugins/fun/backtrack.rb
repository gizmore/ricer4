module Ricer4::Plugins::Fun
  class Backtrack < Ricer4::Plugin
    
    trigger_is :backtrack
    
    has_usage
    def execute
      rply :msg_backtrack
    end
    
  end
end

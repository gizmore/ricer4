module Ricer4::Plugins::Whoami
  class Whoami < Ricer4::Plugin
    
    trigger_is 'whoami'
    has_usage
    def execute
      rply :msg_whoyouare, :user => printjson(sender)
    end
    
  end
end
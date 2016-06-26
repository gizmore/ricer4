module Ricer4::Plugins::Shell
  class Xout < Ricer4::Plugin
    
    trigger_is "xout"
    permission_is :authenticated

    has_usage
    def execute
      sender.logout!
      sender.set_offline
      rply :msg_xout
    end
    
  end
end
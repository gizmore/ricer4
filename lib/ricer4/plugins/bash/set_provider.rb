module Ricer4::Plugins::Bash
  class SetProvider < Ricer4::Plugin
    
    trigger_is "bash.provider"
    
    has_setting name: :provider, type: :bash_provider, scope: :user, permission: :public
    
    def default_provider; get_user_setting(sender, :provider); end
    
  end
end

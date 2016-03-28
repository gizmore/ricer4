module Ricer4::Plugins::Auth
  class Login < Ricer4::Plugin

    trigger_is :login  
    connector_is :irc
    permission_is :registered
    scope_is :user

    always_enabled
    bruteforce_protected
    
    has_usage '<password>'
    def execute(password)
      return rply :err_already_authenticated if user.authenticated?
      return rplyp :err_wrong_password unless user.authenticate!(password)
      broadcast('user/signed/in', sender)
      rply :msg_authenticated
    end
  
  end
end
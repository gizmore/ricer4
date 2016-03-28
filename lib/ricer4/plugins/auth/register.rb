module Ricer4::Plugins::Auth
  class Register < Ricer4::Plugin
    
    trigger_is :register
    connector_is :irc
    scope_is :user

    bruteforce_protected :always => false
    
    has_usage '<password>', function: :register
    def register(password)
      return rply :err_already_registered if sender.registered?
      sender.password = password
      sender.save!
      sender.login!
      rply :msg_registered
      server.broadcast('user/signed/up', sender)
    end
    
    has_usage '<password> <password>', function: :change_password
    def change_password(new_password, old_password)
      bruteforcing?
      return rplyp :err_wrong_password unless sender.authenticate!(old_password)
      sender.password = new_password
      sender.save!
      sender.login!
      rply :msg_changed_pass
      server.broadcast('user/changed/pass', sender)
    end
    
  end
end

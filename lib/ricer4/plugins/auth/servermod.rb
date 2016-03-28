module Ricer4::Plugins::Auth
  class Servermod < Ricer4::Plugin
  
    trigger_is :mods
    
    has_usage  '<user> <permission>', function: :execute_change_for_user
    def execute_change_for_user(user, change_permission)
      return rplyp :err_unregistered unless user.registered?
      old_permission = user.permission
      
      # Check permissions
      sender_permission = sender.permission
      return rplyp :err_permission if sender_permission.may_alter?(old_permission, change_permission)
      
      # Change it
      new_permission = old_permission.merge(change_permission)
      result = old_permission.display_change(old_permission, change_permission)
      
      # No change
      return rplyp :msg_no_change if result.nil?
      
      # Changed!
      user.permissions = new_permission.bit      
      user.save!
      return rply :msg_changed, user:user.display_name, permission: result, server:server.display_name
    end
    
    has_usage  '<user>', function: :execute_show_for_user
    def execute_show_for_user(user)
      rply :msg_mods, 
        user: user.display_name,
        permission: user.permission.display,
        server: user.server.display_name
    end
    
    has_usage  '', function: :execute_show
    def execute_show()
      execute_show_for_user(self.sender)
    end
  
  end
end

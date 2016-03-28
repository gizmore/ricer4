module Ricer4::Plugins::Server
  class Nick < Ricer4::Plugin
    
    trigger_is :nick
    scope_is :everywhere
    permission_is :ircop
    connector_is :irc
    
    has_usage  '<irc_nickname> <password>', function: :execute
    has_usage  '<irc_nickname>', function: :execute
    def execute(nickname, password=nil)
      
      return rply :err_nick_is_online if server.users.online.by_name(nickname).count > 1
      
      # Try to get nick from db
      unless (nick = server.server_nicks.where(:name => nickname).first)
        nick = Ricer4::ServerNickname.new({
          server_id: server.id,
          nickname: nickname,
          password: password,
        })
        server.instance_variable_set('@new_nick', nick)
      end

      # If we give a password, and it changed, and we have persisted already      
      if password.nil != nil
        if nick.password != password
          if nick.persisted?
            nick.password = password
            nick.save!  # We changed the password!
          end
        end
      end
      
      connection.send_nick()
      
    end
    
  end
end

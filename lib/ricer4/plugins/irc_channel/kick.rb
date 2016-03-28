#
# kick a user
# features rejoin on kick
#
module Ricer4::Plugins::IrcChannel
  class Kick < Ricer4::Plugin
    
    trigger_is :kick
    
    has_setting name: :kickjoin, type: :boolean, scope: :channel, permission: :operator, default: false
    
    has_usage '<target|users:true,current_channel:true,online:true>', scope: :channel, permission: :halfop
    def execute(user)
      rply :msg_try_to_kick, user: user.display_name
      server.send_kick(user)
    end
    
    def kicked_user
      
    end
    
    def plugin_init
      arm_subscribe('irc/kick') do |kicked_user|
        broadcast('irc/kicked/self') if kicked_user.is_ricer?
      end
      arm_subscribe('irc/kicked/self') do
        if get_setting(:kickjoin)
          server.connection.send_join(current_message, channel.name)
        end
      end
    end
    
  end
end
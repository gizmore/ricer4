module Ricer4::Plugins::IrcChannel
  class Part < Ricer4::Plugin
    
    trigger_is :part
    
    has_usage '<target|channels:true,online:true>', permission: :ircop
    has_usage '',                                   permission: :operator, scope: :channel
    
    def execute(channel=nil)
      channel ||= self.channel
      disable_autojoin(channel)
      server.connection.send_part(current_message, channel.name) if channel.online
    end
    
    def disable_autojoin(channel)
      join = get_plugin('IrcChannel/Join')
      if join.get_channel_setting(channel, :autojoin)
        join.save_channel_setting(channel, :autojoin, false)
        rply :msg_autojoin_off
      end
    end
    
  end
end

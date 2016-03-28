module Ricer4::Plugins::IrcChannel
  class Join < Ricer4::Plugin
    
    trigger_is :join
    priority_is 70
    permission_is :halfop
    
    has_setting name: :autojoin, type: :boolean, scope: :channel, permission: :operator, default: true

    has_usage '<target|channels:true,current_server:true,online:true>', trailing: true, function: :execute_already_there 
    def execute_already_there(channel)
      erply :err_already_joined
    end
    
    has_usage '<channel_name>'
    has_usage '<channel_name> <password>'
    def execute(channel_name, password=nil)
      @passwords[channel_name.downcase] = password if password
      rply :msg_trying_to_join
      server.connector.send_join(channel_name, password)
    end
    
    # Re-enable autojoin
    def on_join
      if channel
        update_password(channel)
        save_channel_setting(channel, :autojoin, true)
      end
    end
    
    def update_password(channel)
      if password = @passwords[channel.name.downcase]
        if (password != channel.password)
          channel.password = password
          channel.save!
          @passwords.delete(channel.name.downcase)
          password.gsub!(/./, 'x')
          bot.log.info("Password for #{channel.name} has been updated.")
        end
      end
    end
    
    # Some handlers
    def plugin_init
      @passwords = {}
      # Autojoin some channels
      arm_subscribe('irc/001') do |message|
        server.channels.each do |channel|
          if get_channel_setting(channel, :autojoin)
            server.connector.send_join(channel.name, channel.password)
          end
        end
      end
      # Disable autojoin on a ban
      arm_subscribe('irc/474') do |message|
        if channel = Ricer4::Channel.where(:name => args[1], :server_id => server.id).first
          save_channel_setting(channel, :autojoin, false)
        end
      end
    end

  end
end

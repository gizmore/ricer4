module Ricer4::Plugins::Conf
  class ChannelEncoding < Ricer4::Plugin
    
    trigger_is "channel.encoding"
    
    has_usage  '', scope: :channel , function: :execute_show
    has_usage  '<channel>', function: :execute_show

    has_usage  '<encoding>', permission: :operator, scope: :channel , function: :execute_set
    has_usage  '<channel> <encoding>', permission: :ircop, function: :execute_set_channel
    
    def execute_show(channel=nil)
      channel ||= self.channel
      have = channel.encoding || channel.server.encoding
      rply(:msg_show,
        iso: have.to_label,
        channel: channel.display_name,
      )
    end

    def execute_set(encoding)
      execute_set_channel(channel, encoding)
    end
    
    def execute_set_channel(channel, encoding)
      have = channel.encoding
      channel.encoding = encoding
      channel.save!
      rply(:msg_set,
        :channel => channel.display_name,
        :old => have.to_label,
        :new => encoding.to_label,
      )
    end

  end
end

module Ricer4::Plugins::Conf
  class ChannelLang < Ricer4::Plugin
    
    trigger_is :clang
    
    has_usage  '', scope: :channel, function: :execute_show
    has_usage  '<channel>', function: :execute_show

    has_usage  '<locale>', scope: :channel,  permission: :operator, function: :execute_set
    has_usage  '<channel> <locale>', permission: :ircop, function: :execute_set_channel
    
    def execute_show(channel=nil)
      channel ||= self.channel
      rply(:msg_show,
        iso: channel.locale.to_label,
        channel: channel.display_name,
        available: UserLang.available,
      )
    end

    def execute_set(language)
      execute_set_channel(channel, language)
    end
    
    def execute_set_channel(channel, language)
      have = channel.locale
      channel.locale = language
      channel.save!
      rply :msg_set,
        :channel => channel.display_name,
        :old => have.to_label,
        :new => language.to_label
    end

  end
end

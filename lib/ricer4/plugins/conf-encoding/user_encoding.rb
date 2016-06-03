module Ricer4::Plugins::Conf
  class UserEncoding < Ricer4::Plugin
    
    trigger_is :encoding
    
    priority_is 3 # We are called almost first
    
    has_usage  '<user>', function: :execute_show
    has_usage  '', function: :execute_show

    has_usage  '<encoding>', function: :execute_set
    has_usage  '<user> <encoding>', permission: :ircop, function: :execute_set_user
    
    def execute_show(user=nil)
      user ||= sender
      have = user.encoding || user.server.encoding
      rply(:msg_show,
        iso: have.to_label,
        user: user.display_name,
      )
    end

    def execute_set(encoding)
      execute_set_user(sender, encoding)
    end
    
    def execute_set_user(user, encoding)
      have = user.encoding || user.server.encoding
      user.encoding = encoding
      user.save!
      rply(:msg_set,
        :user => user.display_name,
        :old => have.to_label,
        :new => encoding.to_label,
      )
    end
    
    # When we receive a privmsg, we set the encoding to user encoding or server encoding
    def plugin_init
      arm_subscribe('ricer/messaged') do |sender, message|
        # begin
          # user.localize!
          # encoding = user.encoding || server.encoding
          # args[1].force_encoding(encoding.to_label)
        # rescue StandardError => e
          # bot.log.exception(e)
        # end
      end
    end

  end
end

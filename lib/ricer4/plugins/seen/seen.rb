module Ricer4::Plugins::Seen
  class Seen < Ricer4::Plugin
    
    trigger_is :seen
    
    has_usage '<user>'
    has_usage "<user> <boolean|named:'any'>"
    def execute(user, any_message=false)
      klass = any_message ? Entry : Said
      entry = klass.for_user(user).last
      return rply :err_nothing unless entry
      rply :msg_seen
    end
    
    def plugin_init
      arm_subscribe('ricer/messaged') do |sender, message|
        if message.from_user?
          klass = message.is_privmsg? ? Said : Entry
        end
      end
    end
    
    
  end
end
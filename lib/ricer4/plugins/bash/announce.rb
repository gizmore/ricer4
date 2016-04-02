module Ricer4::Plugins::Bash
  class Announce < Ricer4::Plugin
    
    is_announce_trigger "bash.announce"
    
    has_setting name: :providers, type: :bash_provider, scope: :channel, permission: :halfop,      multiple: true
    has_setting name: :providers, type: :bash_provider, scope: :user,    permission: :registered,  multiple: true
    
    def plugin_init
      arm_subscribe('ricer/ready') do
        service_threaded do
          loop do
            sleep 1.minute
            check_latest
            sleep 30.minutes
          end
        end
      end
    end
    
    def check_latest
      Provider.all.each do |provider|
        check_latest_for(provider)
      end
    end
    
    def check_latest_for(provider)
      provider.latest.each do |quote|
        announce_latest(provider, quote)
      end
    end
    
    def announce_latest(provider, quote)
      announce_targets do |target|
        if get_object_setting(target, :providers).include?(provider)
          announce_to(target, quote)
        end
      end
    end
    
    def announce_to(target, quote)
      target.localize!.send_message(announce_message(quote))
    end
    
    def announce_message(quote)
      quote.display_item('ricer4.plugins.bash.announce.msg_new_quotes', nil)
    end
  
  end
end
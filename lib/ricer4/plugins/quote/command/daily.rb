module Ricer4::Plugins::Quote
  class Daily < Ricer4::Plugin
    
    is_announce_trigger "quote.daily"

    has_setting name: :delay, type: :duration, scope: :user,    permission: :registered, default: 4.hours
    has_setting name: :delay, type: :duration, scope: :channel, permission: :halfop,     default: 4.hours
    
    def plugin_init
      arm_subscribe("ricer/ready") do
        daily_quote_thread
      end
    end

    private
    
    def daily_quote_thread
      service_threaded do
        @last = {}
        @start = Time.now
        loop do
          sleep(60)
          announce_targets do |target|
            if should_announce_to(target)
              send_daily_quote(target)
              @last[target] = Time.now
            end
          end
        end
      end
    end
    
    def should_announce_to(target); get_object_setting(target, :delay) < last_announced; end
    def last_announced(target); Time.now - last_announce; end
    def last_announce(target); @last[target] || @start; end
    
    ############
    ### Send ###
    ############
    def send_daily_quote(target)
      if quote = quote_of_the_hour
        announce_quote_to(target)
      end
    end
    
    def announce_quote_to(quote, to)
      to.localize!.send_privmsg(announcement(quote)) if to.online?
    end
    
    def announcement(quote)
      t(:announcement, quote: quote.display_show_item)
    end
    
    def quote_of_the_hour
      Entity.offset(rand(Entity.count)).first
    end

  end
end

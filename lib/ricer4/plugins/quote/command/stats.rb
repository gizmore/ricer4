module Ricer4::Plugins::Quote
  class Stats < Ricer4::Plugin
    
    trigger_is :stats
    
    has_usage
    def execute
      quotes = Ricer4::Plugins::Quote::Entity
      args = {
        count: quotes.count,
        votes: 1,
      }
      if last = quotes.last
        args.merge!({
          last_id: last.id,
          last_by: last.user.display_name,
          last_date: last.display_date,
        })
      end
      rply :msg_stats, args
    end
    
  end
end

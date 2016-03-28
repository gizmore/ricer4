module Ricer4::Plugins::Quote
  class Show < Ricer4::Plugin
    
    trigger_is :quote

    has_usage  "", function: :execute_random
    def execute_random
      execute(Entity.limit(1).offset(bot.rand.rand(1..Entity.count)).first.id)
    end

    has_usage  "<id>", function: :execute
    def execute(id)
      quote = Entity.find(id)
      reply quote.display_show_item(id)
    end
    
  end
end
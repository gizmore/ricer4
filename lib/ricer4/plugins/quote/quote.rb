module Ricer4::Plugins::Quote
  class Quote < Ricer4::Plugin
    
    depends_on 'List/List'
    depends_on 'Vote/Votes'
    
    has_subcommands
    
    is_show_trigger "quote.show", :for => Ricer4::Plugins::Quote::Entity
    
  end
end

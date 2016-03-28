load File.dirname(__FILE__)+"/model/quote.rb"

module Ricer4::Plugins::Quote
  class Quote < Ricer4::Plugin
    
    has_subcommands
    
    is_show_trigger "quote.show", :for => Ricer4::Plugins::Quote::Entity
    
  end
end

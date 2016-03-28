module Ricer4::Plugins::Quote
  class List < Ricer4::Plugin
    
    is_list_trigger "quote.list", :for => Entity, :per_page => 5
    
  end
end

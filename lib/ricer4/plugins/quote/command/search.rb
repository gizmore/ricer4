module Ricer4::Plugins::Quote
  class Search < Ricer4::Plugin
    
    is_search_trigger :search, :for => Entity, :per_page => 5
    
  end
end

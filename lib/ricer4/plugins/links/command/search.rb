module Ricer4::Plugins::Links
  class Search < Ricer4::Plugin
    
    is_list_trigger "search", :for => Model::Link
    
  end
end
module Ricer4::Plugins::Links
  class Show < Ricer4::Plugin
    
    is_list_trigger "show", :for => Model::Link, :search_pattern => '<id>'
    
  end
end

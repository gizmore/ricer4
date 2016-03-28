module Ricer4::Plugins::Links
  class List < Ricer4::Plugin
    
    is_list_trigger "links", :for => Model::Link
    
  end
end

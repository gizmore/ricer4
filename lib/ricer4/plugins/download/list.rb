module Ricer4::Plugins::Download
  class List < Ricer4::Plugin
    
    is_list_trigger "file.list", :for => Ricer4::Plugins::Download::File
    
  end
end
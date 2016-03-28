load File.expand_path("../target.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Channel < Param::Target
    
    def default_options
      { online:nil, multiple:false,
        wildcard:true, autocomplete:false,
        current_server:true, current_channel:false,
        users:false, channels:true, servers:false }
    end
    
  end
end
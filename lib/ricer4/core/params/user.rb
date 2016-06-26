load File.expand_path("../target.rb", __FILE__)
module ActiveRecord::Magic
  class Param::User < Param::Target
    
    def default_options
      { online:nil, multiple:false,
        wildcard:false, autocomplete:false,
        current_server:true, current_channel:true,
        users:true, channels:false, servers:false }
    end
    
  end
end
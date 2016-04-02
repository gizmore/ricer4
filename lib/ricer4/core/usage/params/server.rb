load File.expand_path("../target.rb", __FILE__)
module ActiveRecord::Magic
  class Param::Server < Param::Target
    
    def default_options
      { online:nil,
        wildcard:false, autocomplete:true,
        current_server:false, current_channel:false,
        users:false, channels:false, servers:true,
        ambigious: false }
    end
    
  end
end
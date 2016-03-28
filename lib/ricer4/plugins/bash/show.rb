module Ricer4::Plugins::Bash
  class Show < Ricer4::Plugin
    
    is_show_trigger "bash.show", :for => Ricer4::Plugins::Bash::Quote
    
    def visible_relation(relation)
      relation.where(:provider => get_plugin('Bash/SetProvider').default_provider.name.to_s)
    end

  end
end
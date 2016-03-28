module Ricer4::Plugins::Bash
  class Random < Ricer4::Plugin
    
    is_show_trigger "bash.random", :for => Ricer4::Plugins::Bash::Quote
    
    def visible_relation(relation)
      relation.send(get_plugin('Bash/SetProvider').default_provider.name).order_by_rand
    end

  end
end
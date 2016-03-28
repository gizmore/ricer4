module Ricer4::Plugins::Server
  class Servers < Ricer4::Plugin
    
    is_list_trigger :servers, :for => Ricer4::Server, :per_page => 10
    
    def display_show_item(server, number)
      get_plugin('Server/Server').display_show_item(server, number)
    end

    def display_list_item(server, number)
      server.display_name
    end
    
    def search_relation(relation, search_term)
      relation.with_url_like(search_term)
    end
    
  end
end

module Ricer4::Plugins::Server
  class Server < Ricer4::Plugin
    
    is_show_trigger :server, :for => Ricer4::Server
    
    def display_show_item(server, number)
      uri = URI(server.url)
      t(:show_server,
        url: "#{uri.host}:#{uri.port}",
        server: server.display_name,
        connector: server.connection.display_name,
        throttle: server.throttle,
        users_total: server.users.count,
        users_online: server.users.online.count,
        date_added: l(server.created_at, :long),
      )
    end
    
    def display_list_item(server, number)
      server.display_name
    end
    
    def search_relation(relation, search_term)
      relation.with_url_like(search_term)
    end
    
  end
end

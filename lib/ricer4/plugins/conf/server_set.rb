module Ricer4::Plugins::Conf
  class ServerSet < Ricer4::Plugin
    
    trigger_is 'server.set'
    permission_is :responsible

    has_usage  '<server> <variable> <value>', function: :execute_set_server
    def execute_set_server(server, var, value)
      columns = ServerShow.config_columns
      columns.include?(var.to_s) or return rplyp(:err_server_column, columns: join(columns))
      old_value, server[var] = server[var], value
      server.save!
      rply(:msg_set,
        server: server.display_name,
        varname: var,
        value: server[var],
        old_value: old_value,
      )
    end
    
    has_usage  '<server> <variable>', function: :execute_show_server
    def execute_show_server(server, var)
      rply(:msg_show,
        server: server.display_name,
        varname: var,
        value:server[var],
      )
    end
    
    has_usage  '<variable> <value>', function: :execute_set
    def execute_set(var, value)
      execute_set_server(server, var, value)
    end

    has_usage  '<variable>', function: :execute_show
    def execute_show(var)
      execute_show_server(server, var)
    end

  end
end

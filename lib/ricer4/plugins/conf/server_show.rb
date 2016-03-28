module Ricer4::Plugins::Conf
  class ServerShow < Ricer4::Plugin
    
    trigger_is 'server show'
    permission_is :responsible
    
    def self.config_columns
      Ricer4::Server.column_names - ['id', 'bot_id', 'connector', 'online', 'created_at', 'updated_at']
    end

    has_usage  '<server> <variable>', :scope => :user, function: :execute
    def execute(server, var)
      columns = self.class.config_columns
      return rplyp :err_server_column, columns:columns.join(', ') unless columns.include?(var.to_s)
      rply :msg_show, server: server.display_name, varname: var, value: server[var]
    end
    
    has_usage  '<variable>', function: :execute_
    def execute_(var)
      execute(self.server, var)
    end
    
  end
end

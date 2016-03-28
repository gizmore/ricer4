module Ricer4::Plugins::Conf
  class ChannelSet < Ricer4::Plugin
    
    trigger_is 'channel set'
    permission_is :responsible
    def config_columns
      Ricer4::Channel.column_names - ['id', 'server_id', 'online', 'name', 'locale_id', 'timezone_id', 'encoding_id', 'created_at', 'updated_at']
    end
    
    # Set a channel db value in private query
    has_usage  '<channel> <variable> <value>', :scope => :user, function: :execute_set_for
    def execute_set_for(channel, var, value)
      columns = config_columns
      return rply :err_channel_column, columns: columns.join(', ') unless columns.include?(var.to_s)
      oldvalue = channel[var]
      channel[var] = value
      channel.save!
      rply :msg_set, channel: channel.display_name, varname: var, value: channel[var], oldvalue: oldvalue
    end
    
    # Set a channel db value in channel itself
    has_usage  '<variable> <value>', :scope => :channel, function: :execute_set
    def execute_set(var, value)
      execute_set_for(self.channel, var, value)
    end

    # Show a channel db value in private query
    has_usage  '<channel> <variable>', :scope => :user, function: :execute_show_for
    def execute_show_for(channel, var)
      columns = config_columns
      return rply :err_channel_column, columns:columns.join(', ') unless columns.include?(var.to_s)
      rply :msg_show, channel: channel.display_name, varname: var, value: channel[var]
    end
    
    # Show a channel db value in channel itself
    has_usage  '<variable>', :scope => :channel, function: :execute_show
    def execute_show(var)
      execute_show_for(self.channel, var)
    end

   # List all db fields for a channel via private query
    has_usage  '<channel>', :scope => :user, function: :execute_show_all_for
    def execute_show_all_for(channel)
      columns = config_columns
      rply :msg_show_all, channel: channel.display_name, columns: columns.join(', ')
    end
  
   # List all db fields for a channel
    has_usage  '', :scope => :channel, function: :execute_show_all
    def execute_show_all()
      execute_show_all_for(self.channel)
    end
    
  end
end

module Ricer4::Plugins::Conf
  class Enable < Ricer4::Plugin
    
    trigger_is :enable
    always_enabled
    
    has_usage  '<plugin>', :scope => :user, :permission => :owner, function: :execute_server
    def execute_server(plugin)
      get_plugin('Conf/ConfServer').set_var(plugin, :plugin_enabled, true)
    end

    has_usage  '<plugin>', :scope => :channel, :permission => :operator, function: :execute_channel
    def execute_channel(plugin)
      get_plugin('Conf/ConfChannel').set_var(plugin, :plugin_enabled, true)
    end

  end
end

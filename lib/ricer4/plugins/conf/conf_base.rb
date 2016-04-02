module Ricer4::Plugins::Conf
  class ConfBase < Ricer4::Plugin
  
    # override
    def plugin_description(long); tt("ricer4.plugins.conf.conf.description"); end
    
    def config_channel
      channel
    end
  
    def config_settings(plugin)
      back = {}
      plugin.memory_settings.each do |options|
        if Ricer4::Scope.matching?(options[:scope], config_scope, config_channel)
          back[options[:name]] ||= []
          back[options[:name]].push(options)
        end
      end
      back
    end
    
    def conflicting?(settings)
      count = 0
      settings.each do |options|
        count += 1 if Ricer4::Scope.matching?(options[:scope], config_scope, config_channel)
      end
      count != 1
    end
    
    def change_permitted?(setting)
      config_channel ? setting.has_user_channel_permission?(sender, config_channel) : has_permission? 
    end
    
    def msg_no_trigger(plugin)
      rplyp :msg_no_settings, :trigger => plugin.plugin_name       
    end
    
    def show_vars(plugin)
      settings = config_settings(plugin)
      vars = []
      settings.each do |key,value|
        vars.push("#{key}(#{plugin.scope_setting(config_scope, config_object, key).display_value})")
      end
      return msg_no_trigger(plugin) if settings.empty?
      rplyp :msg_overview, :trigger => plugin.plugin_trigger||plugin_name, :vars => vars.join(', ')
    end
    
    def show_all_vars
    end
    
    def show_var(plugin, varname)
      settings = config_settings(plugin)[varname.to_sym]
      return rplyp :err_no_such_var if settings.nil?
      out = ''
      settings.each do |options|
        setting = plugin.scope_setting(options[:scope], config_object, varname)
        b = setting.persisted? ? "\x02" : ''
        out += " #{setting.get_scope.to_label}=#{b}#{setting.display_value}#{b}"
      end
      setting = plugin.scope_setting(config_scope, config_object, varname)
      out += " = #{setting.display_value}"
      rplyp(:msg_show_var,
        trigger: plugin.plugin_trigger||plugin_name,
        varname: varname,
        values: out.ltrim,
        hint: setting.param.display_example
      )
    end

    def set_var(plugin, varname, value)
      
      settings = config_settings(plugin)[varname.to_sym]
      return rplyp :err_no_such_var if settings.nil?
      return rplyp :err_conflicting if conflicting?(settings)

      options = settings[0]
      setting = plugin.scope_setting(options[:scope], config_object, varname)
      
      return rplyp :err_no_such_var if setting.nil?
      return rplyp :err_permission unless change_permitted?(setting)
      begin
        value = setting.param.input_to_value!(value)
      rescue
        return rplyp :err_invalid_value, trigger: (plugin.plugin_trigger||plugin_name), varname: varname, hint: setting.param.display_examples
      end 
      
      # No change?
      if setting.param.equals_value?(value)
        return rplyp(:msg_no_change,
          configscope: setting.get_scope.to_label,
          trigger: plugin.plugin_trigger||plugin_name,
          varname: varname,
          samevalue: setting.display_value
        ) 
      end

      # Save and reply
      old_label = setting.display_value
      setting.save_value(value)
      rplyp :msg_saved_setting,
        configscope: setting.get_scope.to_label,
        trigger: plugin.plugin_trigger||plugin_name,
        varname: varname,
        oldvalue: old_label,
        newvalue: setting.display_value
    end
    
  end
end

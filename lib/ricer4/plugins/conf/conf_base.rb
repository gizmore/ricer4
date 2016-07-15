module Ricer4::Plugins::Conf
  class ConfBase < Ricer4::Plugin
  
    # override
    def plugin_description(long); tt("ricer4.plugins.conf.conf.description"); end
    
    def config_channel
      channel
    end
  
    def config_settings(plugin)
      back = {}
      plugin.all_memory_settings.each do |options|
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
      settings.each do |key,options|
        vars.push("#{plugin.no_arm_setting_name(key)}(#{plugin.first_matching_db_setting_for_scopes(key, config_scope).display_value})")
      end
      return msg_no_trigger(plugin) if settings.empty?
      rplyp :msg_overview, :trigger => plugin.plugin_trigger||plugin_name, :vars => vars.join(', ')
    end
    
    def show_all_vars
    end
    
    def config_setting_for(plugin, varname)
      config_settings(plugin)[plugin.arm_setting_name(varname)]
    end
    
    def show_var(plugin, varname)
      settings = config_setting_for(plugin, varname)
      return rplyp :err_no_such_var if settings.nil?
      out = ''
      settings.each do |options|
        setting = plugin.scope_setting(varname, options[:scope])
        scopelabel = Ricer4::Scope.by_name(options[:scope]).to_label
        b = setting.persisted? ? "\x02" : ''
        out += " #{scopelabel}=#{b}#{setting.display_value}#{b}"
      end
      setting = plugin.first_matching_db_setting_for_scopes(plugin.arm_setting_name(varname), config_scope)
      out += " = #{setting.display_value}"
      rplyp(:msg_show_var,
        trigger: plugin.plugin_trigger||plugin_name,
        varname: varname,
        values: out.ltrim,
        hint: setting.param.display_examples
      )
    end

    def set_var(plugin, varname, value)
      settings = config_setting_for(plugin, varname)
      return rplyp :err_no_such_var if settings.nil?
      return rplyp :err_conflicting if conflicting?(settings)

      options = settings[0]
      setting = plugin.scope_setting(varname, options[:scope])
      
      return rplyp :err_no_such_var if setting.nil?
      return rplyp :err_permission unless change_permitted?(setting)
      begin
        value = setting.param.input_to_value!(value)
      rescue => e
        return rplyp :err_invalid_value, trigger: (plugin.plugin_trigger||plugin_name), varname: varname, hint: setting.param.display_examples, error: e.to_s
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
        configscope: Ricer4::Scope.by_name(options[:scope]).to_label,
        trigger: plugin.plugin_trigger||plugin_name,
        varname: varname,
        oldvalue: old_label,
        newvalue: setting.display_value
    end
    
  end
end

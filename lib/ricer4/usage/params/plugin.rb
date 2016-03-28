module ActiveRecord::Magic
  class Param::Plugin < Parameter
    
    def default_options; { check_scope: false, check_permission: false }; end
    
    def input_to_value(input)
      bot.loader.get_plugin_for_trigger(input) || bot.loader.get_plugin(input)
    end
    
    def value_to_input(plugin)
      plugin.plugin_name rescue nil
    end

    def invalid_nil!
      invalid!(:err_unknown_plugin)
    end

    def validate!(plugin)
      if option(:check_scope)
        if (option(:check_permission))
          invalid!(:err_scope_and_permission) unless plugin.has_scope_and_permission?
        else
          invalid!(:err_scope) unless plugin.has_scope?
        end
      elsif (option(:check_permission))
        invalid!(:err_permission) unless plugin.has_permission?
      end
    end

  end
end

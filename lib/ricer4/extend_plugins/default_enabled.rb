module Ricer4::Extend::DefaultEnabled
  DEFAULT_ENABLED_OPTIONS ||= {
    disable_perm_server: :ircop,
    disable_perm_channel: :operator,
    disable_perm_bot: :responsible,
  }
  def default_enabled(def_enabled=true, options={})
    class_eval do |klass|
      #############
      ### Valid ###
      #############
      ActiveRecord::Magic::Options.merge(options, DEFAULT_ENABLED_OPTIONS)
      # valid
      raise Ricer4::ConfigException.new("#{klass.name} excepts extender default_enabled to pass a boolean.") unless !!def_enabled == def_enabled
      
      ################
      ### Settings ###
      ################
      if get_class_variable(:@default_enabled).nil?
        define_class_variable(:@default_enabled, def_enabled)
        has_setting name: :plugin_enabled, type: :boolean, scope: :channel, permission: options[:disable_perm_channel], default: def_enabled
        has_setting name: :plugin_enabled, type: :boolean, scope: :server,  permission: options[:disable_perm_server],  default: def_enabled
        has_setting name: :plugin_enabled, type: :boolean, scope: :bot,     permission: options[:disable_perm_bot],     default: def_enabled
      elsif settings = get_class_variable(:@mem_settings)
        set_class_variable(:@default_enabled, def_enabled)
        settings.each do |setting|
          if setting[:name] == :plugin_enabled
            setting[:default] = def_enabled
            setting[:permission] = options["disable_perm_#{setting[:scope]}".to_sym]
          end
        end
      end
      
      ##############
      ### Helper ###
      ##############
      def plugin_enabled?
        get_setting(:plugin_enabled)
      end

      ####################
      ### Exec handler ###
      ####################
      register_exec_function(:exec_enabled_check!)
      def exec_enabled_check!(line)
        unless plugin_enabled?
          raise Ricer4::ExecutionException.new(t('ricer3.extender.default_enabled.err_disabled'))
        end          
      end
      
    end
  end
end

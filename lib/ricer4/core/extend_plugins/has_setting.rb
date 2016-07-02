###
### Provides has_setting extender for plugins.
### Settings can have a scope and a permission who may alter it with "!config".
### Values can be conviniently get, set and shown.
###
### Example:
### has_setting name: :bugs_per_file, type: :integer, scope: :server, permission: :admin, min: -2, max: 100, default: 5 
###
module Ricer4::Extend::HasSetting
  def has_setting(options)
    class_eval do |klass|
      
      # Prefix option name with plugin path name.
      options[:name] = "#{klass.plugin_name}:#{options[:name]}".to_sym

      # Create aliases for overriding arm_setting methods
      if (!klass.respond_to?(:org_arm_get_setting))
        alias_method :org_arm_get_setting, :get_setting 
        alias_method :org_arm_save_setting, :save_setting 
      end

      def self.klass_for_scope(scope)
        case scope
        when :server; Ricer4::Server
        when :channel; Ricer4::Channel
        when :user; Ricer4::User
        when :bot; Ricer4::Plugin
        else; raise Ricer4::ConfigException.new("Unknown scope for has_setting: #{scope}")
        end
      end
      def klass_for_scope(scope)
        self.class.klass_for_scope(scope)
      end
      def object_for_scope(scope)
        case scope
        when :server; current_message.server
        when :channel; current_message.channel
        when :user; current_message.sender
        when :bot; self
        else; raise Ricer4::ConfigException.new("Unknown scope for has_setting: #{scope}")
        end
      end
      
      def db_settings
        Ricer4::Plugin.define_class_variable(:@db_settings, {})
      end
      
      def memory_settings
        Ricer4::Plugin.define_class_variable(:@mem_settings, [])
      end
      

      def arm_setting_name(name)
        "#{self.plugin_name}:#{name}".to_sym
      end
      
      def all_setting_objects(name)
        name = arm_setting_name(name)
        objects = []
        current_message.scopes.each do |scope|
          object_for_scope(scope).setting(name)
        end
        objects
      end
      
      def get_all_current_db_settings(name)
        db_settings = []
        name = arm_setting_name(name)
        scopes = current_message ? current_message.scopes.reverse : [:bot]
        scopes.each do |scope|
          if setting = object_for_scope(scope).db_setting(name)
            db_settings.push(setting)
          end
        end
        db_settings
      end
      
      def get_current_db_setting(name)
        name = arm_setting_name(name)
        current_message.scopes.reverse.each do |scope|
          if setting = object_for_scope(scope).db_setting(name)
            return setting
          end
        end
        nil
      end
        
      def get_setting(name)
        settings = get_all_current_db_settings(name)
        settings.each do |setting|
          if (setting == settings.last) || (setting.persisted?)
            return setting.get_value
          end
        end
        nil
      end
      
      def save_setting(name, value)
        get_current_db_setting(name).save_value(value)
      end
      
      def bot_setting(name); object_for_scope(:bot).db_setting(arm_setting_name(name)); end
      def user_setting(name); object_for_scope(:user).db_setting(arm_setting_name(name)); end
      def channel_setting(name); object_for_scope(:channel).db_setting(arm_setting_name(name)); end
      def server_setting(name); object_for_scope(:server).db_setting(arm_setting_name(name)); end
      
      def get_bot_setting(name); bot_setting(name).get_value; end
      def get_user_setting(name); user_setting(name).get_value; end
      def get_channel_setting(name); channel_setting(name).get_value; end
      def get_server_setting(name); server_setting(name).get_value; end

      def save_bot_setting(name, value); bot_setting(name).save_value(value); end
      def save_user_setting(name, value); user_setting(name).save_value(value); end
      def save_channel_setting(name, value); channel_setting(name).save_value(value); end
      def save_server_setting(name, value); server_setting(name).save_value(value); end
        
      # Hook the arm_setting to the right klass.
      klass.klass_for_scope(options[:scope]).arm_setting(options)
    end
  end
end

module Ricer4
  module Plugins; end
  class PluginLoader
    
    attr_reader :directories
    
    @@directories ||= []
      
    def initialize(config)
      @config = config
      @plugins = {}
    end
    
    def plugins
      @plugins.values
    end
    
    def get_plugin(name)
      @plugins[name]
    end
    
    def get_plugin!(name)
      get_plugin(name) || (raise Ricer4::UnknownPluginException.new(name))
    end

    #######################
    ### Plugin for line ###
    #######################
    def get_plugin_for_line!(line)
      get_plugin_for_line(line) or raise Ricer4::UnknownCommandException.new(line.substr_to(' ')||line)
    end
    
    def get_plugin_for_line(line)
      trigger = line.gsub(')', ' ').substr_to(" ") || line
      get_plugin_for_trigger(trigger)
    end
    
    def get_plugin_for_trigger(trigger)
      @plugins.each_value do |plugin|
        return plugin if plugin.plugin_trigger == trigger
      end
      nil
    end
    
    ############
    ### Init ###
    ############
    def self.add_directory(directory)
#      arm_log.debug("Adding plugin directory #{directory}")
      @@directories.push(directory) unless @@directories.include?(directory)
    end

    def add_directory(directory)
      self.class.add_directory(directory)
    end
    
    def init_plugins
      @plugins.each_value do |plugin|
        plugin.plugin_init
      end
    end
    
    ###################
    ### I18n loader ###
    ###################
    def load_i18n
      I18n.load_path = []
      ActiveRecord::Magic::Translate.init      
      ActiveRecord::Magic::Translate.load_i18n_dir(bot.core_directory)
      @@directories.each do |directory|;  ActiveRecord::Magic::Translate.load_i18n_dir(directory); end
      I18n.reload!
    end

    
    #####################
    ### Plugin loader ###
    #####################
    def load_plugins
      @@directories.each do |directory|
        load_rb_dir("#{directory}/export")
      end
      @@directories.each do |directory|
        load_plugin_dir(directory)
      end
      detect_plugins_rec(Ricer4::Plugins)
      init_plugins
    end
      
    def load_plugin_dir(directory)
      load_rb_dir("#{directory}/model")
      Filewalker.proc_files(directory, '*.rb') do |file|
        load file
      end
      load_rb_dir("#{directory}/command")
    end
    
    def load_rb_dir(directory)
      if File.directory?(directory)
        Filewalker.traverse_files(directory, '*.rb') do |file|
          begin
            load file
#            bot.log.debug("Loaded ruby file: #{file}")
          rescue => e
            bot.log.error("Cannot load rb file: #{file}")
            bot.log.exception(e)
            raise e
          end
        end
      end
    end
    
    ################
    ### Detector ###
    ################
    def detect_plugins_rec(constant)
      constant.constants(false).each do |plugin_group|
        klass = constant.const_get(plugin_group)
        if !klass.is_a?(Module)
        elsif klass < Ricer4::Plugin
          instanciate_plugin(klass)
        elsif klass.is_a?(Module)
          detect_plugins_rec(klass)
        end
      end
      plugins
    end

    def instanciate_plugin(klass)
#      bot.log.info{"Loading plugin #{klass.plugin_name}"}
      return if @plugins.has_key?(klass.plugin_name)
      return if is_blacklisted?(klass.plugin_name)
      plugin = klass.find_or_create_by!(:name => klass.plugin_name)
      plugin.plugin_dir = locate_plugin_dir(plugin)
      @plugins[klass.plugin_name] = plugin
    end
    
    def is_blacklisted?(plugin_name)
      @config.blacklist.each do |item|
        if item.index('/').nil?
          if plugin_name.substr_to('/') == item
            return true
          end
        elsif item == plugin_name
          return true
        end
      end
      return false
    end
    
    def locate_plugin_dir(plugin)
      plugin.class.instance_methods(false).each do |m|
        location = plugin.class.instance_method(m).source_location
        if location[0].index('plugins')
          return location[0].rsubstr_to('/')
        end
      end
      bot.log.warn{"Plugin #{plugin.plugin_name} has no plugin dir!"}
      return @@directories.first
    end
    
  end
end

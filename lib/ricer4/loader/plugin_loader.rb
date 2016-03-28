module Ricer4
  module Plugins; end
  class PluginLoader
    
    attr_reader :directories
      
    def initialize
      @plugins = {}
      @directories = []
    end
    
    def plugins
      @plugins.values
    end
    
    def get_plugin(name)
      @plugins[name]
    end
    
    ############
    ### Init ###
    ############
    def add_directory(directory)
      @directories.push(directory) unless @directories.include?(directory)
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
      load_i18n_dir(bot.core_directory)
      @directories.each do |directory|
        load_i18n_dir(directory)
      end
      I18n.reload!
    end

    def load_i18n_dir(directory)
      Filewalker.traverse_dirs(directory, 'lang') do |file, dir|
        I18n.load_path.push(dir)
      end
    end
    
    #####################
    ### Plugin loader ###
    #####################
    def load_plugins
      @directories.each do |directory|
        load_rb_dir("#{directory}/export")
      end
      @directories.each do |directory|
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
      load_rb_dir("#{directory}/commands")
    end
    
    def load_rb_dir(directory)
      if File.directory?(directory)
        Filewalker.traverse_files(directory, '*.rb') do |file|
          load file
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
      unless @plugins.has_key?(klass.plugin_name)
        plugin = klass.find_or_create_by!(:name => klass.plugin_name)
        plugin.plugin_dir = locate_plugin_dir(plugin)
        @plugins[klass.plugin_name] = plugin
      end
    end
    
    def locate_plugin_dir(plugin)
      plugin.class.instance_methods(false).each do |m|
        location = plugin.class.instance_method(m).source_location
        if location[0].index('plugins')
          return location[0].rsubstr_to('/')
        end
      end
      bot.log.warn{"Plugin #{plugin.plugin_name} has no plugin dir!"}
      return @directories.first
    end
    
  end
end

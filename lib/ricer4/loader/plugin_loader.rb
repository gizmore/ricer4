module Ricer4
  module Plugins; end
  class PluginLoader
    
    attr_reader :directories
      
    def initialize
      @directories = []
    end
    
    def add_directory(directory)
      @directories.push(directory) unless @directories.include?(directory)
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
#      bot.log.debug{"Ricer4::PluginLoader.load_i18n_dir(#{directory})"}
      Filewalker.traverse_dirs(directory, 'lang') do |file, dir|
#        bot.log.info{"Ricer4::PluginLoader added I18n dir: (#{dir})"}
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
    end
      
    def load_plugin_dir(directory)
#      bot.log.debug{"Ricer4::PluginLoader.load_plugin_dir(#{directory})"}
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
    
  end
end
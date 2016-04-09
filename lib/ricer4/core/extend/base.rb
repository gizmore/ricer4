module Ricer4
  module Extend
    module Base
      
      def bot; Ricer4::Bot.instance; end
      def current_message; Ricer4::Thread.current[:ricer_message]; end
      def current_command; Ricer4::Thread.current[:ricer_command]; end
      
    end
    
    module PluginDir
      def add_ricer_plugin_module(dir)
        Ricer4::PluginLoader.add_directory(dir)
      end
    end
    
  end
end

Object.extend Ricer4::Extend::Base
Object.send :include, Ricer4::Extend::Base

Module.send :include, Ricer4::Extend::PluginDir


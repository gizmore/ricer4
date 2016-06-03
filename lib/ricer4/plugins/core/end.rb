module Ricer4::Plugins::Core
  class End < Ricer4::Plugin
    
    include Ricer4::Include::ProcessorPlugin
    
    trigger_is :end
    permission_is :voice
    priority_is 8

    def plugin_init
      arm_subscribe('ricer/processing') do |sender, message|
        if line == triggered_line(message)
          if bot.loader.get_plugin_for_line(line) == self
            get_plugin('Core/Begin').finish
          end
        end
      end
    end
    
  end
end

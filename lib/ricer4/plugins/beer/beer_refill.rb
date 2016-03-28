module Ricer4::Plugins::Beer
  class Refill < Ricer4::Plugin
    
    trigger_is "beer.refill"
    
    scope_is :channel
    
    def beer_plugin
      get_plugin('Beer/Beer')
    end
    has_usage  '', function: :execute_refill
    def execute_refill
      beer_plugin.set_setting(:beer_left, beer_plugin.chest_max)
      rply :msg_refilled, hero: sender.display_name, left: beer_plugin.beer_left_text
    end
    
  end
end

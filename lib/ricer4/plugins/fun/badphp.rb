module Ricer4::Plugins::Fun
  class Badphp < Ricer4::Plugin
    
    trigger_is :badphp
    permission_is :voice
    
    has_usage
    def execute
      reply description
    end
    
  end
end

module Ricer4::Plugins::Fun
  class Blitzed < Ricer4::Plugin
    
    trigger_is :blitzed
    
    has_usage
    def execute
      areply "raps professionally: \"His name is blitzed, he is the ritz!\""
    end
    
  end
end

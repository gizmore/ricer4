module Ricer4::Plugins::Fun
  class SyntaxError < Ricer4::Plugin
    
    trigger_is :syntax_error
    
    has_usage
    def execute
      reply "http://www.youtube.com/watch?v=s7gfWKpD3GU"
    end
    
  end
end

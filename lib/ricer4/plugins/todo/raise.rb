module Ricer4::Plugins::Todo
  class Raise < Ricer4::Plugin
    
    trigger_is "todo.raise"
    
    has_usage "<id>"
    def execute(id)
      byebug
    end
    
  end
end

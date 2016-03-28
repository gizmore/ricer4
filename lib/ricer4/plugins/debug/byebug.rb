module Ricer4::Plugins::Debug
  class Byebug < Ricer4::Plugin
    
    trigger_is :byebug
    permission_is :responsible
    
    has_usage "<message>"
    def execute(line)
      reply "Launching debugger..."
      byebug
      exec_line(line)
      reply "Welcome back!"
    end
    
  end
end

module Ricer4::Plugins::Core
  class ConsoleLog < Ricer4::Plugin
    
    def plugin_init
      arm_subscribe("ricer/incoming") do |line|
        log_line(line, " << ")
      end
      arm_subscribe("ricer/outgoing") do |line|
        log_line(line, " >> ")
      end
    end
    
    def log_line(line, direction_string)
      bot.log.log_puts("#{server.hostname} #{direction_string} #{line}")
    end
    
  end
end
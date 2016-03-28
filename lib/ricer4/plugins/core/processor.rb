module Ricer4::Plugins::Core
  class Processor < Ricer4::Plugin
    
    include Ricer4::Include::ProcessorPlugin

    priority_is 10
    
    def plugin_init
      @parser = Ricer4::CommandParser.new
      arm_subscribe('ricer/messaged') do |message|
        broadcast('ricer/processing', message)
        unless message.processed
          if line = triggered_line(message)
            begin
              Ricer4::Command.current = nil
              @parser.process_line(line)
            rescue StandardError => e
              message.send_reply(Ricer4::Reply.new(e.message, self, Ricer4::Reply::FAILURE))
            ensure
              message.processed = true
            end
          end
        end
      end
    end
    
  end
end
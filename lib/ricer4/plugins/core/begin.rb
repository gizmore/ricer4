module Ricer4::Plugins::Core
  class Begin < Ricer4::Plugin
    
    trigger_is :begin
    permission_is :voice
    priority_is 9

    has_usage  '<plugin>', function: :execute_begin
    has_usage  '<plugin> <message|named:"args">', function: :execute_begin

    def plugin_init
      arm_subscribe('ricer/processing') do |message|
        if has_line? # something to operate on?
          append_line # Catch in our queue
        end
      end
    end

    def has_line?
      sender.instance_variable_defined?(:@multiline_command)
    end
    
    def get_line
      sender.instance_variable_get(:@multiline_command)
    end
    
    def set_line(line)
      sender.instance_variable_set(:@multiline_command, line)
      current_message.processed = true
    end
    
    def set_begin_message
      sender.instance_variable_set(:@multiline_message, current_message)
    end
    
    def get_begin_message
      sender.remove_instance_variable(:@multiline_message)
    end
    
    def append_line
      set_line(get_line + current_message.line + "\n")
    end
    
    def remove_line
      current_message.processed = true
      sender.remove_instance_variable(:@multiline_command)
    end
    
    def execute_begin(plugin, arguments=nil)
      line = plugin.plugin_trigger + ' '
      line += (arguments + ' ') if arguments
      set_line(line)
      set_begin_message
    end
    
    def finish
      return rply :err_no_begin unless has_line?
      broadcast('ricer/messaged', multiline_message)
    end
    
    def multiline_message
      get_begin_message.clone_privmsg(remove_line)
    end

  end
end

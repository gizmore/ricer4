load "ricer4/command/command.rb"

class Ricer4::CommandParser
 
  def initialize
  end
  
  def process_line(line)
    bot.log.debug("CommandParser.process_line #{line}")
    command = parse(line)
    command.process
  end
  
  def parse(line)
    commandify_line(line)
  end
  
  private
  
  def commandify_line(line)
    # The command itself
    command = Ricer4::Command.new(get_plugin(line))

    # If we are in a current command, we invoked via exec_line
    if Ricer4::Command.current
      command.parent = Ricer4::Command.current # so set parent
#      command.tokens.push(command) # and add to tokens
    end


    # Nibble the trigger
    line = line.substr_from(' ') || ''
    # Enrich tree structure
    commandify_command(command, line)
    # The entry point
    command
  end

  def commandify_command(command, line)
    
    i, len, take = 0, line.length, ''
    command_open = false; bracket_open = 0
    string_open = false; escape_open = false
    
    while i < len
      
      char = line[i]; i += 1
      
      # puts "#{i}: '#{char}' --- cmd:#{command_open}, brk:#{bracket_open}, str:#{string_open}, esc:#{escape_open}, take:'#{take}'"
      # byebug

      # Escaped char
      if escape_open; escape_open = false; take += char; next; end
      
      case char
      when '$'
        if command_open; take += '$'; end
        command_open = true

      when '('
        if command_open
          command.push_text(take); take = ""
          command_open = false
          bracket_open += 1
          plugin = get_plugin(line[i..-1])
          next_token = Ricer4::Command.new(plugin)
          i += plugin.plugin_trigger.length
          i = line.index(/[^\s]/, i) || i # Read whitespaces
          next_token.parent = command
          command.tokens.push(next_token)
          command = next_token
        else
          take += char
        end

      when ')'
        if bracket_open > 0
          bracket_open -= 1
          command.push_text(take); take = ""
          command = command.parent or raise Ricer4::NoParentForCommandException.new
        else
          raise Ricer4::BracketNotOpenException.new
        end

      when '"'
        if string_open
          command.push_quote_text(take); take = ""
        end
        string_open = !string_open

      when '\\'
        escape_open = true
        
      # when '|'
        # if bracket_open > 0
          # raise Ricer4::BracketNotClosedException.new
        # else
        # end

      when '&'
        #if bracket_open > 0
        #  raise Ricer4::BracketNotClosedException.new
        #els
        if line[i] == '&' # two consecutive &&
          i += 1 # read the second
          command.push_text(take); take = "" # empty take string and finish cmd
          i = line.index(/[^\s]/, i) || i # Read whitespaces
          plugin = get_plugin(line[i..-1]) # Next token is a trigger/plugin 
          next_token = Ricer4::Command.new(plugin) # Gen command from plugin
          next_token.parent = command.parent # Copy the parent 
          i += plugin.plugin_trigger.length # We read the trigger
          command.next = next_token # We chain..
          next_token.prev = command # both dir..
          command = next_token # the next cmd...
        else
          take += char
        end
       
       else
         take += char
         
      end
    end
    
    if bracket_open > 0
      raise Ricer4::BracketNotClosedException.new
    end
    
    command.push_text(take)
    
    nil
  end
  
  def get_plugin(line)
    bot.loader.get_plugin_for_line!(line)
  end
  
end

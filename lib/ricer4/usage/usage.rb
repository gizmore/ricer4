module Ricer4
  class Usage
    
    attr_reader :pattern, :options, :params

    def initialize(pattern, options)
      @pattern, @options = pattern, options
      parse_pattern(pattern)
    end

    def parse_pattern(pattern)
      @params = pattern.split(/ +/).collect{ |paramstring| Ricer4::Parameter.from_pattern(paramstring) }
    end
    
    def param(n); @params[n]; end
    def get_permission; @options[:permission]; end
    def get_scope; @options[:scope]; end

    def throws?; @options[:throws]; end
    def allows_trailing?; @options[:traling]; end
    
    def execute(plugin, args)
      ActiveRecord::Base.transaction do
        plugin.send(@options[:function], *args)
      end
    end
    
    #######################
    ### Argument Parser ###
    #######################
    def parse_args(plugin, line)
      # bot.log.debug("Ricer4::Usage.parse_args(#{line}) with pattern: #{@pattern}")
      # bot.log.debug("Ricer4::Usage.parse_args(#{line}) with plugin #{plugin.plugin_name}")
      # empty params
      if @params.empty?
        if allows_trailing?
          [] # allow trailing is always ok
        else # only ok on empty line
          line.empty? ? [] : nil
        end
      else # non empty params
        parse_params(plugin, line)
      end
    end
    
    def parse_cli_args(line)
      cli_args = {}
      take = {}
      
      @params.each do |param|
        if param.only_cli?
          if input = param.get_input
            cli_args[param.named] = input
          end
        end
      end
      
      while true
        line.ltrim!
        token = line.substr_to(' ', '')
        break unless token.starts_with?('--')
        line.substr_from!(' ').ltrim!
        break if token.length == 2
        name = token.substr!(2).substr_to('=', token)
        value = token.substr_from('=', '')
        cli_args[name] = value
      end
      @params.each do |param|
        if cli_args[param.named]
          if param.allow_cli?
            take[param.named] = cli_args.delete(param.named)
          else
            raise Ricer4::CliParameterNotAllowed.new(param)
          end
        end
      end
      
      cli_args.each do |k,v|
        raise Ricer4::UnknownCliParameter.new(k, v)
      end
      take
    end
    
     
    def parse_params(plugin, argline)
      
      # byebug

      back = []
      cli_args = parse_cli_args(argline)

      puts "Usage.parse_params() PATTERN: #{@pattern}"
      puts "Usage.parse_params() ARGLINE: #{argline}"
      puts "Usage.parse_params() CLIARGS: #{cli_args}"
      
      @params.each{ |param|
        
        # byebug
        
        param.prepare(plugin)
        
        unless token = cli_args[param.named]
          if param.only_cli?
            if param.option(:null)
               back.push(nil)
               next
            else
              raise Ricer4::MissingCLIParameterException.new(param)
            end
          end
          
        end
        
        # Out of data!
        raise Ricer4::MissingParameterException.new(param) if argline.empty? && token.nil?

        # <..message..eater..>
        if param.eater
          # bot.log.debug("Usage#parse_params with eater #{param.to_label}: #{argline}")
          back.push(param.input_to_value!(argline))
          return back # Return with rest
        end
        
        # Eat one arg
        unless token # unless cli
          if argline.starts_with?("\x19")
            token = argline.substr_from!("\x19").substr_to("\x19")
            argline.substr_from!("\x19").ltrim!  # nibble
          else
            token = (argline.substr_to(' ')||argline.dup)
            argline.substr_from!(' ').ltrim! # nibble
          end
        end
        # parse error
        value = param.input_to_value!(token)
        return nil if value.nil? && (!param.only_cli?)
        # fine
        back.push(value)
      }
      
      # Tokens left but parsers empty?
      return nil if (!allows_trailing?) && (!argline.empty?)
      
      back 
    end
    
  end
end

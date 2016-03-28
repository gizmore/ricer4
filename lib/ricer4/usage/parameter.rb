module Ricer3
  
  # Put parameters in this module
  module Param; end;

  # Abstract Parameter
  # A parameter can be a setting or a pattern  
  class Parameter
    
    attr_reader :value, :options, :optional, :eater
    
    include Ricer4::Include::Base
    include Ricer4::Include::Readable
    include Ricer4::Include::Translates
    extend Ricer4::Extend::MergesOptions
    
    ###############
    ### Factory ###
    ###############
    # Create a Parameter from a usage pattern snippet like # [<..text..>] or # [<integer|min:5,max:8,test:"abc",arr:[foo],prices:{foo:bar}>]
    def self.from_pattern(pattern)
      optional = pattern.starts_with?('['); pattern.trim!('[]') # parse [optional]
      pattern.trim!('<>') # parse '<>'
      eater = pattern.starts_with?('.'); pattern.trim!('.') # parse ..eater..
      options = options_from_optionstr(pattern.substr_from('|') || '') # parse options:4,foo:5
      classname = (pattern.substr_to('|') || pattern).camelize # parse classname integer:
      param = instanciate(classname, options, optional, eater)
      param.validate_options!
    end
    
    def validate_options!(additional_options=[])
      # Check for unknown
      allowed = all_default_options.keys.concat(additional_options)
      options.keys.each do |key|
        unless allowed.include?(key)
          raise Ricer4::ConfigException.new("Parameter #{display_type} has an invalid parameter option: #{key}")
        end
      end
      # Call sanity func
      options.keys.each do |key|
        method = "validate_option_#{key}!"
        if respond_to?(method)
          unless send(method, option(key))
            raise Ricer4::ConfigException.new("Parameter #{display_type} has an invalid #{key} option: #{option(key)}")
          end 
        end
      end
      self
    end
    def validate_option_default!(value); input_to_value!(value); true rescue false; end
    def validate_option_name!(name); validate_option_symbol!(name); end
#    def validate_option_type!(name); true; end
    def validate_option_named!(named); named.nil? || validate_option_symbol!(named); end
#    def validate_option_scope!(scope); true; end
#    def validate_option_permission!(permission); true; end
    def validate_option_null(null); null == true || null == false; end
    def validate_option_symbol!(symbol); /^[a-zA-Z0-9_]+$/.match(symbol); end
    
    def self.from_settings(setting, options)
      self.from_setting_options(options)
    end
    
    def self.from_setting_options(options)
      param = instanciate(options[:type].to_s.classify, options, true, true)
    end
    
    def self.instanciate(classname, options={}, optional=false, eater=false)
      begin
        klass = ActiveRecord::Magic::Param.const_get(classname)
      rescue NameError => e
        raise Ricer4::ConfigException.new(I18n.t('ricer3.err_unknown_parameter', classname: classname))
      end
      klass.new(options, optional, eater) # instanciate Integer(options, eater, optional)
    end
    
    # Parse optionstring part of a pattern into hash.
    # @param optionstr String @example: min=5,default="foo,bar",blub=blab,styles=[foo,bar]
    def self.options_from_optionstr(optionstr='')
      eval "{#{optionstr}}"
    end

    ################
    ### Override ###
    ################
#    def own_multi_handler?; false; end
    def default_eater; false; end
    def default_options; {}; end
    def value_to_input(value); value.to_s; end
    def input_to_value(input); input.to_s; end
    def validate!(value); end
    def display_example; @input.to_s rescue "abc" end
    
    ######################
    ### Convert In/Out ###
    ######################
    def doing_multiple?
      @options[:multiple] # && (!own_multi_handler?)
    end
    def values_to_input(values)
      if doing_multiple?
        inputs = Array(values).collect{|value| value_to_input(value)}
        inputs.length > 1 ? "#{inputs.join(',')}" : inputs[0]
      else
        value_to_input(values)
      end
    end
    
    def input_to_values(inputs)
      if doing_multiple?
        inputs.split(',').collect{|input| input_to_value(input) }
      else
        input_to_value(inputs)
      end
    end

    ################
    ### Validate ###
    ################
    def prepare(plugin)
      @plugin = plugin
    end
    
    def input_to_value!(input)
      #bot.log.debug("#{self.class.name}.input_to_value!(#{input})")
#      (input.nil? || (input.respond_to?(:empty?) && input.empty?)) ? nil :
      input == nil ? nil : validates!(input_to_values(input.to_s))
    end
    
    def validates!(values)
      if values.nil?
        invalid_nil! unless options[:null]
      else
        Array(values).map{|value|validate!(value)}
      end
      values
    end
     
    def invalid!(key, args={})
      raise Ricer4::ParameterException.new(display_name, t(key, args))
    end

    def invalid_nil!
      invalid!('ricer3.param.err_nil_not_allowed', {type: display_type})
    end
    
    def invalid_type!
      invalid!('ricer3.param.err_type', {type: display_type})
    end

    ######################
    ### Parameter core ###
    ######################
    def _default_options; { default: nil, null: false, named: nil, cli: false, multiple: false }; end
    def all_default_options; default_options.reverse_merge(_default_options); end
    
    def initialize(options={}, optional=false, eater=false)
      @options = options.reverse_merge(all_default_options)
      @optional, @eater = optional, eater||default_eater
#      set_value(init_default_value)
    end
    
    def set_default_value
      set_value(init_default_value)
    end
    
    def init_default_value
      value = default_value
      return nil if value.nil?
      return default_input_to_value(value)
    end
    
    def default_input_to_value(input)
      return input unless input.is_a?(::String) || input.is_a?(::Symbol) 
      input_to_value!(input)
    end
    
    def option(key); @options[key]; end
    def default_value; option(:default); end
    
    ###########
    ### CLI ###
    ###########
    def cli_option; options[:cli] == nil ? nil : !!@options[:cli]; end
    def allow_cli?; cli_option != false; end
    def only_cli?; cli_option == true; end

    
    def display_type
      t!(:type) rescue self.class.name.rsubstr_from('::').downcase
    end
    
    def display_name
      return display_type if @options[:named].nil?
      t!("ricer3.param.#{option(:named)}.type") rescue option(:named)
    end
    
    def named
      @_named ||= (option(:named) || self.class.name.rsubstr_from('::').downcase)
    end
    
    def display_value
      @input
    end
    
    def display_examples
      t("ricer3.param.examples", example: display_example)
    end
    
    def get_input
      @input
    end

    def get_value
      @value
    end
    
    def set_input(input)
      @input = input
      @value = input_to_values(input)
    end
    
    def set_value(value)
      @input = values_to_input(value)
      @value = value
    end
    
    def equals_value?(value)
      @value == value
    end
    
  end
end

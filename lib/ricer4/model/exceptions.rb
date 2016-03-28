module Ricer4
  
  class Exception < StandardError
    def initialize(text="")
      super(text)
    end
  end
  
  class ConfigException < Exception; end
  class GeneralException < Exception; end
  class RuntimeException < Exception; end
  class ExecutionException < Exception; end
  class WrongScopeException < Exception; end
  class NoPermissionException < Exception; end
  class SilentCancelException < Exception; end

  class BracketNotOpenException < Exception; def message; I18n.t('ricer3.err_bracket_not_open'); end; end
  class BracketNotClosedException < Exception; def message; I18n.t('ricer3.err_bracket_not_closed'); end; end
  class NoParentForCommandException < Exception; def message; I18n.t('ricer3.err_no_parent_for_command'); end; end
  
  class ParameterException < Exception
    attr_reader :parameter_name
    def initialize(pn,msg)
      @parameter_name = pn
      @text = msg
      def message
        I18n.t('ricer3.err_invalid_parameter', parameter_name: @parameter_name, reason: @text)
      end
    end
  end
  
  class UnknownCliParameter < ParameterException
    def initialize(key,value)
      @key,@value = key,value
    end
    def message
      I18n.t('ricer3.err_unknown_cli_parameter', key:@key, value:@value)
    end
  end
  class CliParameterNotAllowed < ParameterException
    def initialize(param)
      @param = param
    end
    def message
      I18n.t('ricer3.err_cli_parameter_not_allowed', param: @param.display_name)
    end
  end
  
  class MissingParameterException < ParameterException
    def initialize(p)
      @p = p
    end
    def message
      I18n.t('ricer3.err_missing_parameter', parameter_name: @p.display_name, parameter_type: @p.display_type)    
    end
  end

  class MissingCLIParameterException < MissingParameterException
    def message
      I18n.t('ricer3.err_missing_cli_parameter', parameter_name: @p.display_name, parameter_type: @p.display_type)    
    end
  end
  
  class UnknownCommandException < Exception
    attr_reader :plugin_trigger
    def initialize(t)
      @plugin_trigger = t
    end
    def message
      I18n.t('ricer3.err_unknown_command', trigger: @plugin_trigger)
    end
  end
  
  class UnknownConnectorException < Exception
    def initialize(connector) 
      @connector = connector
    end
    def message
      I18n.t('ricer3.err_unknown_connector', connector: @connector)
    end
  end

end

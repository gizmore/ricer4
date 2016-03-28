module Ricer4::Plugins::Conf
  class ConfServer < ConfBase
    
    trigger_is :confs
    always_enabled

    has_usage  '<plugin> <variable> <value>', function: :set_var
    has_usage  '<plugin> <variable>', function: :show_var
    has_usage  '<plugin>', function: :show_vars

    def config_scope; [:server]; end
    def config_object; server; end 

  end
end
